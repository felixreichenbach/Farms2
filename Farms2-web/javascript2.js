
// Retrieve App ID from URL
var hostname = $(location).attr('hostname');
var res = hostname.split(".");
console.log(res[0])

// Initialize Realm App client with App ID retrieved from URL

const app = new Realm.App({ id: res[0] });

async function loginEmailPassword(email, password) {
    // Create an credential
    const credentials = Realm.Credentials.emailPassword(email, password);

    try {
        // Authenticate the user
        const user = await app.logIn(credentials);
        // `App.currentUser` updates to match the logged in user
        console.assert(user.id === app.currentUser.id)
        return user
    } catch (err) {
        console.error("Failed to log in", err);
    }
}

$(document).ready(function () {
    /*
    console.log(app.currentUser.id);
    if (app.currentUser.id) {
        $('.form-signin').hide();
        $('#orderForm').show();
    }
    */
    // Add order item
    const orderItem = {"name":"Greetings from Farms 2 Web Client"}
    $("#addButton").click(async function () {
        const result = await app.functions.newOrder(orderItem);
    });

    // Login User

    $('.form-signin').submit(async function (event) {
        event.preventDefault();
        loginEmailPassword("foo@bar.com", "password")
            .then(user => {
                console.log("Successfully logged in!", user)
                $('.form-signin').hide();
                $('#orderForm').show();
            })
    });

    $('#logout').click(async function() {
        //stub
    })
});

