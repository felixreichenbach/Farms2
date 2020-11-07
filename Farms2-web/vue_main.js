const RootComponent = {
    data() {
        return {
            isLoggedIn: false,
            name: "Felix"
        }
    },
    methods: {
        login() {
            console.log("Logged In!")
            this.isLoggedIn = true
        }
    }
}

const app = Vue.createApp(RootComponent)

app.component('profile', {
    props: ['name'],
    template: `
    <p>User: {{ name }}</p>`
})

app.component('loginForm', {
    data() {
        return {
            email: null,
            password: null
        }

    },
    props: ['isLoggedIn'],
    methods: {
        handleSubmit(e) {
            console.log(JSON.stringify(e))
            if (this.email && this.password) {
                this.$emit('login')
            } else {
                console.log("Form Incomplete")
            }

        }
    },
    template: `
    <form @submit.prevent="handleSubmit">
        <label for="loginEmail">Email</label>
        <input type="email" id="email" v-model="email" placeholder="Email Address" autocomplete="username">
        <label for="password">Password</label>
        <input type="password" id="password" v-model="password" placeholder="Password" autocomplete="current-password">
        <button id="loginButton" type="submit">Sign in</button>
        <p id="loginError"></p>
    </form>`
})

const vm = app.mount('#app')


// learning https://www.vuemastery.com/courses/intro-to-vue-3/attribute-binding-vue3