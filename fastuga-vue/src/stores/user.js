import { ref, computed, inject } from "vue";
import { defineStore } from "pinia";
import avatarNoneUrl from "@/assets/avatar-none.png";

export const useUserStore = defineStore("user", () => {
  const axios = inject("axios");
  const serverBaseUrl = inject("serverBaseUrl");

  const user = ref(null);

  // Web Sockets
  const socket = inject("socket");

  const userId = computed(() => {
    return user.value?.id ?? -1;
  });

  const userPhotoUrl = computed(() => {
    if (!user.value?.photo_url) {
      return avatarNoneUrl;
    }
    return serverBaseUrl + "/storage/fotos/" + user.value.photo_url;
  });

  async function loadUser() {
    try {
      const response = await axios.get("users/me");
      user.value = response.data.data;
    } catch (error) {
      clearUser();
      throw error;
    }
  }
  function clearUser() {
    delete axios.defaults.headers.common.Authorization;
    sessionStorage.removeItem("token");
    user.value = null;
  }

  async function login(credentials) {
    try {
      const response = await axios.post("login", credentials);
      axios.defaults.headers.common.Authorization =
        "Bearer " + response.data.access_token;
      sessionStorage.setItem("token", response.data.access_token);
      await loadUser();

      // Send message to web sockets that the user Logged In
      socket.emit("loggedIn", user.value);

      return true;
    } catch (error) {
      clearUser();
      return false;
    }
  }

  async function logout() {
    try {
      await axios.post("logout");

      // Send message to web sockets that the user Logged Out
      socket.emit("loggedOut", user.value);

      clearUser();
      return true;
    } catch (error) {
      return false;
    }
  }

  /*  async function register(credentials) {
        try {
            await axios.post('register', credentials)
            return true
        } catch (error) {
            return response
        }
    }*/

  async function restoreToken() {
    let storedToken = sessionStorage.getItem("token");
    if (storedToken) {
      axios.defaults.headers.common.Authorization = "Bearer " + storedToken;
      await loadUser();

      // Send message to web sockets that the user Logged In
      socket.emit("loggedIn", user.value);

      return true;
    }
    clearUser();
    return false;
  }

  //==================================================
  // Web Sockets
  //==================================================

  // Listen for the 'message' event from the server and log the data
  // received from the server to the users.

  // waits for the user updated message
  socket.on("updateUser", (updatedUser) => {
    if (user.value?.id == updatedUser.id) {
      user.value = updatedUser;
      toast.info("Your user profile has been changed!");
    } else {
      toast.info(
        `User profile #${updatedUser.id} (${updatedUser.name}) has changed!`
      );
    }
  });

  return {
    user,
    userId,
    userPhotoUrl,
    loadUser,
    clearUser,
    login,
    logout,
    restoreToken,
  };
});
