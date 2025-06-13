<template>
    <div class="month-container">
      <div v-if="!loading" class="month-header">
        {{ monthName }} {{ year }}
      </div>

      <div class="calendar-grid">
        <div
          v-for="(day, idx) in flatDays"
          :key="idx"
          class="calendar-cell"
        >
          <DaySchedule v-if="day" :day="day" />
        </div>
      </div>
    </div>
  </template>

  <script>
  import { fetchContentPlanItemsByMonthAll } from './services/api';
  import DaySchedule from './DaySchedule.vue';

  export default {
    name: 'MonthComponent',
    components: { DaySchedule },           // ← Регистрируем локально
    props: {
      month:   { type: Number, required: true }, // 0–11
      year:    { type: Number, required: true },
      loading: { type: Boolean, default: false }
    },
    data() {
      return {
        days:  [],
        weeks: []
      };
    },
    computed: {
      // Чтобы шаблон не ругался
      monthName() {
        return new Date(this.year, this.month)
          .toLocaleString('ru-RU', { month: 'long' });
      },
      flatDays() {
        // «сплющенный» список дней + null-ов
        return this.weeks.flat();
      }
    },
    watch: {
      month: 'fetchMonthData',
      year:  'fetchMonthData'
    },
    mounted() {
      this.fetchMonthData();
    },
    methods: {
      async fetchMonthData() {
        this.$emit('update:loading', true);
        try {
          // API ждёт месяц 1–12
          const items = await fetchContentPlanItemsByMonthAll(
            this.year,
            this.month + 1
          );

          const totalDays = new Date(this.year, this.month + 1, 0).getDate();
          const todayStr  = new Date().toDateString();

          const days = Array.from({ length: totalDays }, (_, i) => {
            const d   = new Date(this.year, this.month, i + 1);
            const dd = String(d.getDate()).padStart(2, '0');
            const mm = String(d.getMonth() + 1).padStart(2, '0');
            const iso = `${d.getFullYear()}-${mm}-${dd}`;
            const dayItems = items.filter(it => it.deadline === iso);

            return {
              date:            d,
              weekday:         ['ПН','ВТ','СР','ЧТ','ПТ','СБ','ВС'][(d.getDay()+6)%7],
              isToday:         d.toDateString() === todayStr,
              hasPublication:  dayItems.length > 0,
              missedPublication: dayItems.some(it => !it.posted) && d < new Date(),
              publications:    dayItems
            };
          });

          this.days  = days;
          this.weeks = this.groupDaysIntoWeeks(days);
        } catch (err) {
          console.error(err);
        } finally {
          this.$emit('update:loading', false);
        }
      },

      groupDaysIntoWeeks(days) {
        const weeks   = [];
        let   week    = [];
        // отступ пустыми, если месяц не начинается с ПН
        const firstDow = (new Date(this.year, this.month, 1).getDay() + 6) % 7;
        for (let i = 0; i < firstDow; i++) week.push(null);

        days.forEach(day => {
          week.push(day);
          if (week.length === 7) {
            weeks.push(week);
            week = [];
          }
        });
        if (week.length) {
          while (week.length < 7) week.push(null);
          weeks.push(week);
        }
        return weeks;
      }
    }
  };
  </script>

  <style scoped>
  .month-container { margin-bottom: 20px; }
  .month-header  { font-size: 24px; font-weight: bold; margin: 10px 0; }

  .calendar-grid {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 10px;
    grid-auto-rows: auto;
  }
  .calendar-cell {
    display: flex;
    flex-direction: column;
  }
  </style>
