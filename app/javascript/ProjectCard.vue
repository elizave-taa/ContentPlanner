<script setup>
import {BBadge, BButton, BCard} from "bootstrap-vue-next";
</script>

<template>
  <div class="card-wrapper">
    <BCard
        tag="article"
        class="blur-card"
    >
      <div class="card-image-container">
        <img
            src="/images/illustration.png"
            alt="Card image"
            class="card-image"
        >
        <div class="image-gradient"></div>
        <div class="card-title">Card Title</div>
      </div>

      <div class="card-body">
        <div class="badges-container">
          <BBadge variant="primary">Телеграм</BBadge>
          <BBadge variant="secondary">Инстаграм</BBadge>
          <BBadge variant="success">ВК</BBadge>
          <BBadge variant="danger">YT</BBadge>
        </div>
        <div class="publication-date">Публикация: дата</div>
      </div>
    </BCard>
  </div>
</template>

<style scoped>
.card-wrapper {
  max-width: 300px;
  max-height: 400px;
  transition: transform 0.3s ease;
}

.card-wrapper:hover {
  transform: scale(1.05);
  z-index: 1;
}

.card-image-container {
  position: relative;
  height: 140px;
  width: 100%;
  overflow: hidden;
}

.blur-card {
  border: none!important;
  background: rgba(255, 255, 255, 0.5)!important;
  border-radius: 18px!important;
  height: 100%;
}

.card-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.image-gradient {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 70%;
  background: linear-gradient(to top, rgb(81, 57, 71), transparent);
}

.card-title {
  position: absolute;
  bottom: 15px;
  left: 15px;
  color: white;
  font-size: 30px;
  font-weight: 500;
  z-index: 2;
}

.card-body {
  padding: 1rem;
}

.badges-container {
  margin-bottom: 15px;
  display: flex;
  flex-wrap: wrap;
  gap: 5px;
}

.publication-date {
  font-size: 0.8rem;
  color: #6c757d;
}
</style>