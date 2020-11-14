// Initialize Realm App client with App ID retrieved from URL
const realmApp = new Realm.App({ id: "farms2-hbvuz" });


async function realmlogin(username, password) {
    const credentials = Realm.Credentials.emailPassword(username, password);
    try {
        // Authenticate the user
        const user = await realmApp.logIn(credentials);
        // `App.currentUser` updates to match the logged in user
        console.assert(user.id === realmApp.currentUser.id)
        return user
    } catch (err) {
        return err
    }
}

// Vue.js Components

const RootComponent = {
    data() {
        if (realmApp.currentUser) {
            return {
                isLoggedIn: realmApp.currentUser.isLoggedIn
            }
        } else {
            return { isLoggedIn: false }
        }
    },
    methods: {
        async login() {
            this.isLoggedIn = true
        }
    }
}

const app = Vue.createApp(RootComponent)


app.component('loginForm', {
    data() {
        return {
            email: null,
            password: null,
            error: null
        }
    },
    props: ['isLoggedIn'],
    methods: {
        async handleSubmit() {
            if (this.email && this.password) {
                await realmlogin(this.email, this.password).then(result => {
                    if (!result.error) {
                        this.$emit('login')
                    } else {
                        this.error = result.error
                    }
                })

            } else {
                this.error = "Form Incomplete"
            }
        }
    },
    template: `
    <form @submit.prevent="handleSubmit">
        <div class="form-group">
            <label for="loginEmail">Email</label>
            <input type="email" id="email" v-model="email" placeholder="Email Address" autocomplete="username" class="form-control">
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" v-model="password" placeholder="Password" autocomplete="current-password" class="form-control">
        </div>
        <button id="loginButton" type="submit" class="btn btn-primary">Sign in</button>
        <p id="loginError">{{ error }}</p>
    </form>`
})


app.component('profile', {
    data() {
        return { name: realmApp.currentUser.profile.email }
    },
    methods: {
        logout() {
            realmApp.currentUser.logOut().then(result => {
                this.$root.isLoggedIn = false
            })

        }
    },
    template: `
    <p>User: {{ name }}</p>
    <button v-on:click="logout" class="btn btn-primary">Logout</button>`
})


app.component('listitems', {
    data() {
        return {
            items: [
                {
                    id: 1,
                    name: 'Do the dishes'
                },
                {
                    id: 2,
                    name: 'Take out the trash'
                },
                {
                    id: 3,
                    name: 'Mow the lawn'
                }
            ]
        }
    },
    methods: {
    },
    components: {
        'listitem': {
            props: ['item'],
            template: `<li class="list-group-item">{{ item.name }}</li>`
        }
    },
    template: `
    <ul class="list-group"><listitem v-for="item in items" v-bind:item="item" v-bind:key="item.id"></listitem></ul>`
})

const vm = app.mount('#app')


// learning https://www.vuemastery.com/courses/intro-to-vue-3/attribute-binding-vue3