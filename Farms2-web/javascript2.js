
// Retrieve App ID from URL
var hostname = $(location).attr('hostname');
var res = hostname.split(".");
//console.log(res[0])

// Initialize Realm App client with App ID retrieved from URL
const app = new Realm.App({ id: 'farms2-hbvuz' });

async function loginEmailPassword(email, password) {
    // Create a credential
    const credentials = Realm.Credentials.emailPassword(email, password);

    try {
        // Authenticate the user
        const user = await app.logIn(credentials);
        // `App.currentUser` updates to match the logged in user
        console.assert(user.id === app.currentUser.id)
        return user
    } catch (err) {
        //console.error("Failed to log in", err);
    }
}

$(document).ready(function () {

    // Check if a user is logged in
    if (app.currentUser) {
        $('#login').hide();
        $('#orderForm').show();
    }

    // Login User
    $("#loginForm").submit(function (event) {
        var email = $("#loginEmail").val();
        var password = $("#password").val();
        event.preventDefault();

        loginEmailPassword(email, password).then(user => {
            if (app.currentUser) {
                console.log("Successfully logged in!", user)
                $('#loginError').text('');
                $('#login').hide();
                $('#orderForm').show();
            } else {
                $('#loginError').text('Login failed!');
            }
        });
    });

    // Logout current user
    $('#logout').click(async function () {
        console.log("logout: ", app.currentUser._profile.email)
        await app.currentUser.logOut();
        $('#login').show();
        $('#orderForm').hide();
    })

    // Add order item
    const orderItem = { "name": "Greetings from Farms 2 Web Client" }
    $("#addButton").click(async function () {
        const result = await app.functions.newOrder(orderItem);
    });
});