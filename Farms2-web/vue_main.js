const RootComponent = {
    data() {
        return { count: 4 }
    }
}

const app = Vue.createApp(RootComponent)

app.component('profile', {
    data() {
        return {
            isLoggedIn: true,
            name: "Felix"
        }
    },
    template: `
    <p v-if="isLoggedIn">
      Email: {{ name }}
    </p>`
})

app.component('loginForm', {
    data() {
        return {
            isLoggedIn: true,
            name: "Agnes"
        }
    },
    template: `
    <form v-if="isLoggedIn">
        <label for="loginEmail">Email</label>
        <input type="email" id="loginEmail" placeholder="Email Address">
        <label for="password">Password</label>
        <input type="password" id="password" placeholder="Password">
        <button id="loginButton" type="submit">Sign in</button>
        <p id="loginError"></p>
    </form>`
})


const vm = app.mount('#app')


// learning https://www.vuemastery.com/courses/intro-to-vue-3/attribute-binding-vue3