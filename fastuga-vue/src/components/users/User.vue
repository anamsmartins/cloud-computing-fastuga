<script setup>
  import { ref, watch, inject } from 'vue'
  import UserDetail from "./UserDetail.vue"
  import { useRouter, onBeforeRouteLeave } from 'vue-router'  
import { useUserStore } from "../../stores/user.js"
  
  const router = useRouter()  
  const axios = inject('axios')
  const toast = inject('toast')

const userStore = useUserStore()

const socket = inject("socket")

  const props = defineProps({
      id: {
        type: Number,
        default: null
      }
  })

  const newUser = () => {
      return {
        id: null,
        name: '',
        email: '',
        gender: 'M',
        photo_url: null
      }
  }

  let originalValueStr = ''
  const loadUser = (id) => {    
    originalValueStr = ''
      errors.value = null
      if (!id || (id < 0)) {
        user.value = newUser()
        originalValueStr = dataAsString()
      } else {
        axios.get('users/' + id)
          .then((response) => {
            user.value = response.data.data
            originalValueStr = dataAsString()
          })
          .catch((error) => {
            console.log(error)
          })
      }
  }

  const save = () => {
      errors.value = null
      /*axios.put('users/' + props.id, user.value)
        .then((response) => {
          user.value = response.data.data

          // Web Socket - Sends Message to websocket that the user was updated
          socket.emit('updateUser', user.value)
          if (user.value.id == userStore.user.id) {
            userStore.user = user.value
          }

          originalValueStr = dataAsString()
          toast.success('User #' + user.value.id + ' was updated successfully.')
          router.back()
        })
        .catch((error) => {
          if (error.response.status == 422) {
              toast.error('User #' + props.id + ' was not updated due to validation errors!')
              errors.value = error.response.data.errors
            } else {
              toast.error('User #' + props.id + ' was not updated due to unknown server error!')
            }
        })*/
  }

  const cancel = () => {
    originalValueStr = dataAsString()
    router.back()
  }

  const dataAsString = () => {
      return JSON.stringify(user.value)
  }

  let nextCallBack = null
  const leaveConfirmed = () => {
      if (nextCallBack) {
        nextCallBack()
      }
  }

  onBeforeRouteLeave((to, from, next) => {
    nextCallBack = null
    let newValueStr = dataAsString()
    if (originalValueStr != newValueStr) {
      nextCallBack = next
      if(confirmationLeaveDialog.value){
        confirmationLeaveDialog.value.show()
      }
    } else {
      next()
    }
  })  

  const user = ref(newUser())
  const errors = ref(null)
  const confirmationLeaveDialog = ref(null)

  watch(
    () => props.id,
    (newValue) => {
        loadUser(newValue)
      },
    {immediate: true}  
    )

</script>

<template>
  <user-detail
    :user="user"
    :errors="errors"
    @save="save"
    @cancel="cancel"
  ></user-detail>
</template>
