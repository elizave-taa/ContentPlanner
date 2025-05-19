<template>
  <div
      class="day"
      :class="{
      'today': day.isToday,
      'has-publication': day.hasPublication,
      'missed-publication': day.missedPublication
    }"
      :data-date="day.date.getTime()"
  >
    <div class="day-header">
      <span class="weekday">{{ day.weekday }}</span>
      <span class="date">{{ day.date.getDate() }}.0{{ day.date.getMonth() + 1 }}</span>
    </div>

    <div v-if="day.hasPublication" class="publications">
      <div
          v-for="(pub, index) in day.publications"
          :key="index"
          class="publication"
          :class="{ 'missed': !pub.completed && day.date < new Date() }"
      >
        {{ pub.specialist }}
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    day: {
      type: Object,
      required: true,
      validator: (value) => {
        // Проверяем обязательные поля
        return (
            value.date instanceof Date &&
            typeof value.weekday === 'string' &&
            typeof value.isToday === 'boolean' &&
            typeof value.hasPublication === 'boolean' &&
            typeof value.missedPublication === 'boolean' &&
            Array.isArray(value.publications)
        );
      }
    }
  }
}
</script>

<style scoped>
.day {
  padding: 10px;
  min-height: 60px;
  margin-bottom: 10px;
  background: rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(25px);
  border-radius: 18px;
}

.day-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 5px;
  font-weight: bold;
}

.weekday {
  color: #666;
}

.date {
  color: #333;
}
.today {
  background-color: #e6f7ff;
}
.missed-publication {
  background-color: #fff0f0;
}

.publication {
  padding: 2px 5px;
  color: #4a2c40;
  border-radius: 3px;
  margin: 2px 0;
  font-size: 0.9em;
  border-color: #4a2c40;
  background-color: #fff;
}

.publication.missed {
  background-color: #f44336;
}
</style>