<template>
  <div class="flex flex-col items-center justify-center min-h-screen bg-gray-100">
    <h1 class="text-xl text-amber-700">Hello, world!</h1>
    <p class="text-gray-700">This is a simple Vue app using Tailwind CSS.</p>
    <ul class="list-disc list-inside">
      <li>Item 1</li>
      <li>Item 2</li>
      <li>Item 3</li>
    </ul>
    <button @click="handleClick" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
      Click Me
    </button>
    <p class="text-gray-500">This is a paragraph with some gray text.</p>
  </div>
</template>

<script>
export default {
  name: "App",
  methods: {
    handleClick() {
      alert("Hello from Vue!");
    },
  },
};
</script>

<style scoped>
</style>