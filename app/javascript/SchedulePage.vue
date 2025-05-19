<template>
  <GeneralNavBar></GeneralNavBar>
  <div class="calendar-container">
    <div class="calendar-header">
      <div>Календарь публикаций {{ currentYear }}</div>
    </div>

    <div class="weeks-scroll" ref="scrollContainer" @scroll="handleScroll">
      <div class="weeks-wrapper">
        <BRow v-for="(week, weekIndex) in visibleWeeks" :key="weekIndex" class="week-row" :ref="'week-' + weekIndex">
          <BCol
              v-for="day in week"
              :key="day.date.getTime()"
              cols="6" sm="4" md="3" lg="2" xl="12/7"
              class="day-col"
          >
            <DayComponent
                :day="day"
                class="day-item"
            />
          </BCol>
        </BRow>
      </div>
    </div>

    <div v-if="loading" class="loading">Загрузка...</div>
  </div>
</template>

<script>
import DayComponent from './DaySchedule.vue';
import { BRow, BCol } from "bootstrap-vue-next";
import GeneralNavBar from "./GeneralNavBar.vue";
import throttle from 'lodash.throttle';

export default {
  components: {
    GeneralNavBar,
    DayComponent,
    BRow,
    BCol
  },
  data() {
    return {
      visibleDays: [],
      visibleWeeks: [],
      loading: false,
      currentCenterDate: new Date(),
      daysPerLoad: 70, // Загружаем по 10 недель за раз
      currentYear: new Date().getFullYear(),
      scrollObserver: null
    };
  },
  mounted() {
    this.loadInitialDays();
    this.setupScrollObserver();
  },
  beforeDestroy() {
    if (this.scrollObserver) {
      this.scrollObserver.disconnect();
    }
  },
  methods: {
    setupScrollObserver() {
      // Используем IntersectionObserver для определения видимой недели
      this.scrollObserver = new IntersectionObserver(
          (entries) => {
            entries.forEach(entry => {
              if (entry.isIntersecting) {
                const weekIndex = parseInt(entry.target.getAttribute('data-week-index'));
                const week = this.visibleWeeks[weekIndex];
                if (week && week.length > 0) {
                  this.currentYear = week[0].date.getFullYear();
                }
              }
            });
          },
          {
            root: this.$refs.scrollContainer,
            threshold: 0.5
          }
      );

      // Начинаем наблюдение после загрузки данных
      this.$nextTick(() => {
        this.visibleWeeks.forEach((week, index) => {
          const weekElement = this.$refs[`week-${index}`]?.[0]?.$el;
          if (weekElement) {
            weekElement.setAttribute('data-week-index', index);
            this.scrollObserver.observe(weekElement);
          }
        });
      });
    },

    loadInitialDays() {
      this.loadMoreDays(this.currentCenterDate, 'before');
      this.loadMoreDays(this.currentCenterDate, 'after');

      this.$nextTick(() => {
        this.scrollToToday();
      });
    },

    groupDaysIntoWeeks(days) {
      const weeks = [];
      let currentWeek = [];

      days.forEach((day, index) => {
        currentWeek.push(day);

        if (currentWeek.length === 7 || index === days.length - 1) {
          weeks.push([...currentWeek]);
          currentWeek = [];
        }
      });

      return weeks;
    },

    loadMoreDays(centerDate, direction = 'after') {
      if (this.loading) return;
      this.loading = true;

      const newDays = [];
      const date = new Date(centerDate);

      if (direction === 'before') {
        date.setDate(date.getDate() - this.daysPerLoad);
      }

      for (let i = 0; i < this.daysPerLoad; i++) {
        const currentDate = new Date(date);
        if (direction === 'before') {
          currentDate.setDate(date.getDate() + i);
        } else {
          currentDate.setDate(date.getDate() + i);
        }

        const dayData = this.generateDayData(currentDate);
        newDays.push(dayData);
      }

      if (direction === 'before') {
        this.visibleDays = [...newDays, ...this.visibleDays];
      } else {
        this.visibleDays = [...this.visibleDays, ...newDays];
      }

      this.visibleWeeks = this.groupDaysIntoWeeks(this.visibleDays);
      this.loading = false;

      // После загрузки новых данных обновляем наблюдатель
      this.$nextTick(this.setupScrollObserver);
    },

    generateDayData(date) {
      date.setHours(0, 0, 0, 0);
      const today = new Date();
      today.setHours(0, 0, 0, 0);

      const publications = this.getPublicationsForDate(date);

      return {
        date: date,
        weekday: ['ВС', 'ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ'][date.getDay()],
        isToday: date.getTime() === today.getTime(),
        hasPublication: publications.length > 0,
        missedPublication: publications.some(pub => !pub.completed) && date < today,
        publications: publications
      };
    },

    getPublicationsForDate(date) {
      if (date.getDate() % 3 === 0) {
        return [
          { specialist: 'Иванов', completed: Math.random() > 0.3 },
          { specialist: 'Петров', completed: Math.random() > 0.3 }
        ];
      }
      return [];
    },

    handleScroll: throttle(function() {
      const container = this.$refs.scrollContainer;
      const scrollTop = container.scrollTop;
      const scrollHeight = container.scrollHeight;
      const clientHeight = container.clientHeight;

      if (scrollTop + clientHeight >= scrollHeight - 200) {
        const lastDay = this.visibleDays[this.visibleDays.length - 1];
        if (lastDay) {
          this.loadMoreDays(lastDay.date, 'after');
        }
      }

      if (scrollTop <= 200) {
        const firstDay = this.visibleDays[0];
        if (firstDay) {
          this.loadMoreDays(firstDay.date, 'before');
          this.$nextTick(() => {
            const newHeight = container.scrollHeight;
            container.scrollTop = newHeight - scrollHeight + scrollTop;
          });
        }
      }
    }, 200),

    scrollToToday() {
      const todayIndex = this.visibleWeeks.findIndex(week =>
          week.some(day => day.isToday)
      );
      if (todayIndex >= 0) {
        const container = this.$refs.scrollContainer;
        const weekElement = this.$refs[`week-${todayIndex}`]?.[0]?.$el;
        if (weekElement) {
          weekElement.scrollIntoView({
            behavior: 'auto',
            block: 'start'
          });
          // Устанавливаем текущий год
          const week = this.visibleWeeks[todayIndex];
          if (week && week.length > 0) {
            this.currentYear = week[0].date.getFullYear();
          }
        }
      }
    }
  }
};
</script>

<style scoped>
.calendar-container {
  width: 100%;
  padding: 20px;
  height: 93vh;
  display: flex;
  flex-direction: column;
  background-color: #e3c3d4;
}

.calendar-header {
  margin-bottom: 15px;
  color: #4a2c40;
  font-weight: 400;
  font-size: 30px;
  padding: 0 20px;
}

.weeks-scroll {
  overflow-y: auto;
  flex-grow: 1;
  padding: 10px 10px;
  /* Скрываем скроллбар */
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE и Edge */
}

/* Скрываем скроллбар в Chrome, Safari и Opera */
.weeks-scroll::-webkit-scrollbar {
  display: none;
}

.weeks-wrapper {
  display: flex;
  flex-direction: column;
}

.week-row {
  margin-bottom: 10px;
  padding: 0 5px;
}

.day-col {
  padding: 0 5px;
  margin-bottom: 10px;
}

.day-item {
  height: 100%;
}

.loading {
  text-align: center;
  padding: 10px;
  color: #666;
}

/* Для экранов xl показываем 7 дней в строке */
@media (min-width: 1200px) {
  .day-col {
    flex: 0 0 calc(100% / 7);
    max-width: calc(100% / 7);
  }
}
</style>