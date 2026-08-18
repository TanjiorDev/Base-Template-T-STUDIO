<script setup>
import { ref } from 'vue'
import { Form, Field, ErrorMessage } from 'vee-validate'
import * as yup from 'yup'
import moment from 'moment'

const submitting = ref(false)

const onSubmit = async (values) => {
  if (submitting.value) return
  submitting.value = true

  try {
    await fetch('http://esx_identity/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify({
        firstname: values.firstname,
        lastname: values.lastname,
        dateofbirth: moment(values.dob).format('DD/MM/YYYY'),
        sex: values.gender,
        height: values.height,
      }),
    })
  } finally {
    setTimeout(() => {
      submitting.value = false
    }, 900)
  }
}

const schema = yup.object({
  firstname: yup.string().required('Le prénom est obligatoire').min(3, 'Minimum 3 caractères'),
  lastname: yup.string().required('Le nom est obligatoire').min(3, 'Minimum 3 caractères'),
  dob: yup.date()
    .required('La date de naissance est obligatoire')
    .min(new Date('1900-01-01'), 'Date trop ancienne')
    .max(moment().subtract(1, 'years').toDate(), 'Date invalide'),
  gender: yup.string().required('Sélectionnez un genre'),
  height: yup.number().required('La taille est obligatoire').min(120, 'Minimum 120 cm').max(220, 'Maximum 220 cm').typeError('La taille doit être un nombre'),
})
</script>

<template>
  <div class="identity-shell">
    <div class="identity-card">
      <aside class="identity-card__aside">
        <div class="aside-copy">
          <p class="aside-eyebrow">CRÉATION</p>
          <h1>CHARACTER<br><span>IDENTITY</span></h1>
          <p class="aside-description">Créez et personnalisez<br>votre personnage.</p>
          <span class="aside-line"></span>
        </div>

        <div class="profile-visual" aria-hidden="true">
          <span class="orbit orbit--outer"></span>
          <span class="orbit orbit--inner"></span>
          <div class="profile-icon">
            <svg viewBox="0 0 24 24" fill="none">
              <path d="M12 12.2a4.1 4.1 0 1 0 0-8.2 4.1 4.1 0 0 0 0 8.2Z" fill="currentColor"/>
              <path d="M4.6 20c.45-4.15 3.1-6.2 7.4-6.2s6.95 2.05 7.4 6.2H4.6Z" fill="currentColor"/>
            </svg>
          </div>
        </div>

        <div class="aside-dots" aria-hidden="true"></div>
      </aside>

      <main class="identity-card__content">
        <Form id="register" class="identity-form" action="#" novalidate :validation-schema="schema" @submit="onSubmit">
          <div class="field-block">
            <div class="field-row">
              <div class="field-icon">
                <svg viewBox="0 0 24 24"><path d="M12 12.2a4.1 4.1 0 1 0 0-8.2 4.1 4.1 0 0 0 0 8.2ZM4.7 20c.4-4.1 3.05-6.15 7.3-6.15S18.9 15.9 19.3 20H4.7Z"/></svg>
              </div>
              <label for="firstname">Prénom</label>
              <Field id="firstname" name="firstname" type="text" placeholder="Prénom" autocomplete="off" validateOnInput />
            </div>
            <ErrorMessage name="firstname" class="field-error" />
          </div>

          <div class="field-block">
            <div class="field-row">
              <div class="field-icon">
                <svg viewBox="0 0 24 24"><path d="M12 12.2a4.1 4.1 0 1 0 0-8.2 4.1 4.1 0 0 0 0 8.2ZM4.7 20c.4-4.1 3.05-6.15 7.3-6.15S18.9 15.9 19.3 20H4.7Z"/></svg>
              </div>
              <label for="lastname">Nom</label>
              <Field id="lastname" name="lastname" type="text" placeholder="Nom" autocomplete="off" validateOnInput />
            </div>
            <ErrorMessage name="lastname" class="field-error" />
          </div>

          <div class="field-block">
            <div class="field-row">
              <div class="field-icon">
                <svg viewBox="0 0 24 24"><path d="M7 2h2v3H7V2Zm8 0h2v3h-2V2ZM5 4h14a2 2 0 0 1 2 2v14H3V6a2 2 0 0 1 2-2Zm0 6v8h14v-8H5Zm2 2h3v2H7v-2Zm5 0h3v2h-3v-2Z"/></svg>
              </div>
              <label for="dob">Date de naissance</label>
              <Field id="dob" name="dob" type="date" validateOnInput />
            </div>
            <ErrorMessage name="dob" class="field-error" />
          </div>

          <div class="field-block">
            <div class="field-row field-row--gender">
              <div class="field-icon">
                <svg viewBox="0 0 24 24"><path d="M14 3h7v7h-2V6.4l-3.25 3.25A7 7 0 1 1 14.35 8.2L17.6 5H14V3ZM9.5 10a4.5 4.5 0 1 0 0 9 4.5 4.5 0 0 0 0-9Z"/></svg>
              </div>
              <label>Genre</label>
              <div class="gender-options">
                <label class="gender-option" for="male">
                  <Field id="male" name="gender" type="radio" value="m" validateOnInput />
                  <span class="radio-dot"></span>
                  <span>Homme</span>
                </label>
                <label class="gender-option" for="female">
                  <Field id="female" name="gender" type="radio" value="f" validateOnInput />
                  <span class="radio-dot"></span>
                  <span>Femme</span>
                </label>
              </div>
            </div>
            <ErrorMessage name="gender" class="field-error" />
          </div>

          <div class="field-block">
            <div class="field-row">
              <div class="field-icon">
                <svg viewBox="0 0 24 24"><path d="M8 2h8v20H8V2Zm3 2v2h2V4h-2Zm0 4v2h3V8h-3Zm0 4v2h2v-2h-2Zm0 4v2h3v-2h-3Z"/></svg>
              </div>
              <label for="height">Taille</label>
              <div class="height-input">
                <Field id="height" name="height" type="text" inputmode="numeric" placeholder="175" validateOnInput />
                <span>cm</span>
              </div>
            </div>
            <ErrorMessage name="height" class="field-error" />
          </div>

          <button class="create-button" type="submit" :disabled="submitting">
            <svg viewBox="0 0 24 24"><path d="M15 12a4 4 0 1 0-6 0c-3.2.5-5 2.45-5.4 5.7h9.55A5.9 5.9 0 0 1 15 12Zm4-1v3h3v2h-3v3h-2v-3h-3v-2h3v-3h2Z"/></svg>
            <span>{{ submitting ? 'CRÉATION...' : 'CRÉER' }}</span>
          </button>
        </Form>
      </main>
    </div>
  </div>
</template>
