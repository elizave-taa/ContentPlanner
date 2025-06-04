<template>
  <BModal
    id="code-modal"
    ref="modal"
    title="Введите код доступа"
    @hidden="resetModal"
    @ok="handleOk"
    v-model="modalShow"
  >
    <form ref="form" @submit.stop.prevent="handleSubmit">
      <BFormGroup
        label-for="code-input"
        invalid-feedback="Поле обязательно для заполнения"
        :state="codeState"
      >
        <BFormInput
          id="code-input"
          v-model="code"
          :state="codeState"
          required
        ></BFormInput>
      </BFormGroup>
    </form>
  </BModal>
</template>

<script>
import { BModal, BFormInput, BFormGroup } from "bootstrap-vue-next";

export default {
  components: {
    BModal,
    BFormInput,
    BFormGroup
  },
  props: {
    modelValue: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      code: '',
      codeState: null
    }
  },
  computed: {
    modalShow: {
      get() {
        return this.modelValue;
      },
      set(value) {
        this.$emit('update:modelValue', value);
      }
    }
  },
  methods: {
    checkFormValidity() {
      const valid = this.$refs.form.checkValidity();
      this.codeState = valid;
      return valid;
    },
    resetModal() {
      this.$emit('close-modal');
      this.resetCode();
    },
    handleOk(bvModalEvent) {
      bvModalEvent.preventDefault();
      this.handleSubmit();
    },
    handleSubmit() {
      if (!this.checkFormValidity()) {
        return;
      }
      this.$emit('code-submitted', this.code);
    },
    resetCode() {
      this.code = '';
      this.codeState = null;
    }
  }
}
</script>
