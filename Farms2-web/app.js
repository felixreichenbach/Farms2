
// Initialize Realm App client with App ID retrieved from URL
const app = new Realm.App({ id: "farms2-hbvuz" });

const Login = {
    data() {
        return {
            input: {
                username: "",
                password: "",
                status: ""
            }
        }
    },
    methods: {
        async login() {
            if (this.input.username != "" && this.input.password != "") {

                const credentials = Realm.Credentials.emailPassword(this.input.username, this.input.password);

                try {
                    // Authenticate the user
                    const user = await app.logIn(credentials);
                    // `App.currentUser` updates to match the logged in user
                    console.assert(user.id === app.currentUser.id)

                    this.input.status = "Successfully Logged In!"
            
                    //mongodb = app.currentUser.mongoClient("mongodb-atlas");
                    //mongoCollection = mongodb.db("Farms2").collection("MyOrder");

                } catch (err) {
                    this.input.status = "Failed to log in: " + err;
                }

            } else {
                this.input.status = "A username and password must be present"
            }
        }
    }
}

Vue.createApp(Login).mount('#loginForm')