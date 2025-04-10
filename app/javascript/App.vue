<template>
  <div class="flex flex-col items-center justify-center min-h-screen bg-gray-100">
    <h1 class="text-xl text-amber-700">Hello, world!</h1>
    <p class="text-gray-700">This is a simple Vue app using Tailwind CSS and Bootstrap Vue.</p>

    <!-- Bootstrap Vue компонент -->
    <BAlert variant="success" class="mt-4">This is a Bootstrap Vue alert!</BAlert>

    <BButton variant="primary" @click="handleClick" class="mt-4">
      Bootstrap Button
    </BButton>
  </div>
</template>

<script>
export default {
  name: "App",
  methods: {
    handleClick() {
      alert("Hello from Vue with Bootstrap!");
    },
  },
};
</script>