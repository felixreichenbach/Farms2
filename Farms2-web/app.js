const Counter = {
    data() {
        return {
            message: 124
        }
    },
    mounted() {
        setInterval(() => {
            this.message++
        }, 1000)
    },
    methods: {
        reverseMessage() {
            this.message = "ola"
        }
    }
}

Vue.createApp(Counter).mount('#counter')