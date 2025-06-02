<template>
  <BModal
    id="code-modal"
    ref="modal"
    title="Введите код доступа"
    @hidden="resetModal"
    @ok="handleOk"
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
  data() {
    return {
      code: '',
      codeState: null
    }
  },
  methods: {
    checkFormValidity() {
      const valid = this.$refs.form.checkValidity();
      this.codeState = valid;
      return valid;
    },
    resetModal() {
      this.code = '';
      this.codeState = null;
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
      this.$nextTick(() => {
        this.$bvModal.hide('code-modal');
      });
    },
    show() {
      this.$bvModal.show('code-modal');
    },
    hide() {
      this.$bvModal.hide('code-modal');
    }
  }
}
</script>