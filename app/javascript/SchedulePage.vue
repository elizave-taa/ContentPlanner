<template>
  <GeneralNavBar/>

  <div class="calendar-container">
    <div class="calendar-header">
      <div class="header-title">Календарь публикаций {{ currentYear }}</div>
      <b-button
        size="sm"
        variant="primary"
        @click="scrollToCurrentMonth"
      >
        Текущий месяц
      </b-button>
    </div>

    <div
      class="months-scroll"
      ref="scrollContainer"
      @scroll="handleScroll"
    >
      <div class="months-wrapper">
        <MonthComponent
          v-for="(m, idx) in visibleMonths"
          :key="`${m.year}-${m.month}`"
          :month="m.month"
          :year="m.year"
          :loading="loading"
          @update:loading="loading = $event"
          :ref="`month-${idx}`"
          :data-month-index="idx"
        />
      </div>
    </div>

    <div v-if="loading" class="loading">
      <b-spinner small type="grow" label="Loading…" class="mr-2" />
      Загрузка...
    </div>
  </div>
</template>

<script>
import GeneralNavBar from "./GeneralNavBar.vue";
import MonthComponent from "./MonthComponent.vue";
import { BButton, BSpinner } from "bootstrap-vue-next";
import throttle from "lodash.throttle";

export default {
  components: { GeneralNavBar, MonthComponent, BButton, BSpinner },

  data() {
    return {
      visibleMonths: [],
      loading: false,
      currentYear: new Date().getFullYear(),
      monthsPerLoad: 3,
      scrollObserver: null
    };
  },

  mounted() {
    this.loadInitialMonths();
    this.$nextTick(() => {
      this.setupScrollObserver();
      this.scrollToCurrentMonth();
    });
  },

  beforeDestroy() {
    if (this.scrollObserver) {
      this.scrollObserver.disconnect();
    }
  },

  methods: {
    loadInitialMonths() {
      this.loading = true;
      const today = new Date();
      this.visibleMonths = Array.from({ length: this.monthsPerLoad }, (_, i) => {
        const m = new Date(today.getFullYear(), today.getMonth() + i, 1);
        return { month: m.getMonth(), year: m.getFullYear() };
      });
      this.$nextTick(() => { this.loading = false; });
    },

    loadMoreMonths(centerDate, direction = "after") {
      if (this.loading) return;
      this.loading = true;

      const base = new Date(centerDate);
      const chunk = [];

      if (direction === "before") {
        base.setMonth(base.getMonth() - this.monthsPerLoad);
        for (let i = 0; i < this.monthsPerLoad; i++) {
          const m = new Date(base.getFullYear(), base.getMonth() + i, 1);
          chunk.push({ month: m.getMonth(), year: m.getFullYear() });
        }
        this.visibleMonths = [...chunk, ...this.visibleMonths];
      } else {
        base.setMonth(base.getMonth() + 1);
        for (let i = 0; i < this.monthsPerLoad; i++) {
          const m = new Date(base.getFullYear(), base.getMonth() + i, 1);
          chunk.push({ month: m.getMonth(), year: m.getFullYear() });
        }
        this.visibleMonths = [...this.visibleMonths, ...chunk];
      }

      this.$nextTick(() => {
        if (direction === "before") {
          const c = this.$refs.scrollContainer;
          const addedHeight = [...this.$refs[`month-0`][0].$el.parentNode.children]
            .slice(0, this.monthsPerLoad)
            .reduce((sum, el) => sum + el.getBoundingClientRect().height, 0);
          c.scrollTop += addedHeight;
        }
        this.loading = false;
      });
    },

    setupScrollObserver() {
      if (this.scrollObserver) return;
      this.scrollObserver = new IntersectionObserver(
        entries => {
          entries.forEach(entry => {
            if (!entry.isIntersecting) return;
            const idx = Number(entry.target.dataset.monthIndex);
            this.currentYear = this.visibleMonths[idx].year;
          });
        },
        { root: this.$refs.scrollContainer, threshold: 0.5 }
      );

      this.visibleMonths.forEach((_, i) => {
        const comp = this.$refs[`month-${i}`];
        if (comp && comp[0] && comp[0].$el) {
          const el = comp[0].$el;
          el.setAttribute("data-month-index", i);
          this.scrollObserver.observe(el);
        }
      });
    },

    scrollToCurrentMonth() {
      const today = new Date();
      const idx = this.visibleMonths.findIndex(
        m => m.year === today.getFullYear() && m.month === today.getMonth()
      );
      if (idx === -1) return;
      const comp = this.$refs[`month-${idx}`];
      if (comp && comp[0] && comp[0].$el) {
        comp[0].$el.scrollIntoView({ behavior: "smooth", block: "start" });
      }
    },

    handleScroll: throttle(function() {
      if (this.loading) return;

      const c = this.$refs.scrollContainer;
      const { scrollTop, scrollHeight, clientHeight } = c;

      if (scrollTop + clientHeight >= scrollHeight - 200) {
        const last = this.visibleMonths[this.visibleMonths.length - 1];
        this.loadMoreMonths(new Date(last.year, last.month, 1), "after");
      }
      if (scrollTop <= 200) {
        const first = this.visibleMonths[0];
        this.loadMoreMonths(new Date(first.year, first.month, 1), "before");
      }
    }, 200)
  }
};
</script>

<style scoped>
.calendar-container {
  width: 100%;
  height: 93vh;
  padding: 20px;
  display: flex;
  flex-direction: column;
  background-color: #e3c3d4;
}
.calendar-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding: 0 20px;
}
.header-title {
  font-size: 30px;
  color: #4a2c40;
}
.months-scroll {
  flex-grow: 1;
  overflow-y: auto;
  padding: 10px;
  scrollbar-width: none;
  -ms-overflow-style: none;
}
.months-scroll::-webkit-scrollbar {
  display: none;
}
.months-wrapper {
  display: flex;
  flex-direction: column;
}
.loading {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 10px;
  color: #666;
}
</style>