<template>
  <BFormGroup :label="title">
    <div v-for="(link, index) in modelValue" :key="index" class="link-item mb-3" :style="link._destroy ? 'display: none;' : ''">
      <div class="input-group">
        <BFormInput
            v-if="withTitles"
            v-model="link.title"
            placeholder="Заголовок"
            class="flex-grow-1"
        />
        <BFormInput
            v-model="link.url"
            type="url"
            class="flex-grow-1"
        />
        <BButton
            @click="removeLink(index)"
            variant="danger"
            size="sm"
            class="remove-btn"
        >
          ×
        </BButton>
      </div>
    </div>
    <BButton @click="addLink" class="add-btn" size="sm">
      + Добавить ссылку
    </BButton>
  </BFormGroup>
</template>

<script>
import { BFormGroup, BFormInput, BButton } from 'bootstrap-vue-next'

export default {
  components: { BButton, BFormInput, BFormGroup },
  props: {
    modelValue: {
      type: Array,
      required: true,
      default: () => []
    },
    title: String,
    withTitles: Boolean
  },
  methods: {
    addLink() {
      const newLink = this.withTitles ? { title: '', url: '' } : { url: '' }
      this.$emit('update:modelValue', [...this.modelValue, newLink])
    },
    removeLink(index) {
      const links = [...this.modelValue]
      if (links[index].id) {
        links[index]._destroy = true;
      } else {
        links.splice(index, 1);
      }
      this.$emit('update:modelValue', links)
    }
  }
}
</script>

<style scoped>
.input-group {
  display: flex;
  align-items: center;
  gap: 8px;
}
.flex-grow-1 {
  flex-grow: 1;
  padding: 0.25rem 0.5rem;
  font-size: 0.875rem;
  height: calc(1.2em + 0.5rem + 2px);
  line-height: 1.5;
}
.remove-btn {
  flex-shrink: 0;
  width: 32px;
  height: 25px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
}
.add-btn {
  background: none !important;
  border-color: #4a2c40 !important;
  color: #4a2c40 !important;
  margin-bottom: 10px;
}
</style>
