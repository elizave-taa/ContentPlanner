<template>
  <div
    class="day"
    :class="{
      today: day.isToday,
      'has-publication': day.hasPublication,
      'missed-publication': day.missedPublication
    }"
  >
    <div class="day-header">
      <span class="weekday">{{ day.weekday }}</span>
      <span class="date">{{ formattedDate }}</span>
    </div>

    <div v-if="day.hasPublication" class="publications">
      <div
        v-for="pub in day.publications"
        :key="pub.id"
        class="publication"
        :class="{ missed: !pub.posted && pub.overdue }"
      >
        {{ pub.title }}
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'DaySchedule',
  props: {
    day: {
      type: Object,
      required: true
    }
  },
  computed: {
    // Возвращает строку вида "01.10", "05.06", "31.12" и т.д.
    formattedDate() {
      const d = this.day.date.getDate();
      const m = this.day.date.getMonth() + 1;
      const dd = String(d).padStart(2, '0');
      const mm = String(m).padStart(2, '0');
      return `${dd}.${mm}`;
    }
  }
};
</script>

<style scoped>
 .day {
   padding: 10px;
   display: flex;
   flex-direction: column;
   background: rgba(255,255,255,0.3);
   backdrop-filter: blur(25px);
   border-radius: 18px;
   height: 100%;
   position: relative;           /* для псевдо-элементов, если захотите */
 }
 .day-header {
   display: flex;
   justify-content: space-between;
   margin-bottom: 5px;
   font-weight: bold;
 }
 .weekday { color: #666; }
 .date    { color: #333; }

.today {
  background-color: #e6f7ff;   /* прежний фон */
  border: 2px solid #1890ff;   /* подчёркиваем границей */
  box-shadow: 0 0 0 4px rgba(24,144,255,0.2);
}

 .missed-publication { background-color: #fff0f0; }

 .publications {
   flex: 1;
   display: flex;
   flex-direction: column;
 }
 .publication {
   padding: 4px 6px;
   margin-bottom: 4px;
   border-radius: 4px;
   border: 1px solid #4a2c40;
   background: #fff;
   font-size: .9em;
 }
 .publication.missed {
   background-color: #f44336;
   color: #fff;
 }
</style>
