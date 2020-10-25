
// Retrieve App ID from URL
var hostname = $(location).attr('hostname');
var res = hostname.split(".");
//console.log(res[0])

// Initialize Realm App client with App ID retrieved from URL
const app = new Realm.App({ id: res[0] });
var mongo;
var mongoCollection;

async function loginEmailPassword(email, password) {
    // Create a credential
    const credentials = Realm.Credentials.emailPassword(email, password);

    try {
        // Authenticate the user
        const user = await app.logIn(credentials);
        // `App.currentUser` updates to match the logged in user
        console.assert(user.id === app.currentUser.id)
        mongo = app.services.mongodb("mongodb-atlas");
        mongoCollection = mongo.db("demo").collection("pos");
        return user
    } catch (err) {
        //console.error("Failed to log in", err);
    }
}

$(document).ready(function () {

    // Check if a user is logged in
    if (app.currentUser) {
        $('#loginContainer').hide();
        $('#ordersListContainer').show();
        $('#orderFormContainer').show();
    }

    // Login User
    $("#loginButton").click(function(){
        $("#loginForm").submit(function (event) {
            console.log("Submit loginForm");
            var email = $("#loginEmail").val();
            var password = $("#password").val();
            event.preventDefault();

            loginEmailPassword(email, password).then(user => {
                if (app.currentUser) {
                    console.log("Successfully logged in!", user)
                    $('#loginError').text('');
                    $('#loginContainer').hide();
                    $('#ordersListContainer').show();
                    $('#orderFormContainer').show();
                } else {
                    $('#loginError').text('Login failed!');
                }
            });
        });
    });

    // Logout current user
    $('#logout').click(async function () {
        console.log("logout: ", app.currentUser._profile.email)
        await app.currentUser.logOut();
        $('#loginContainer').show();
        $('#ordersListContainer').hide();
        $('#orderFormContainer').hide();
    })

    // Add order item based upon selection
    $("#addButton").click(function () {
        let value = $("#inputGroupSelect option:selected").text()

        console.log($("#inputGroupSelect option:selected").val())
        if ($("#inputGroupSelect option:selected").val() !== "Choose...") {
            let x = $("#orderItems").children().length
            x++
            console.log(x)
            $("#orderItems").append(
                `<li class="list-group-item">
                        <div class="form-group">
                            <label for="orderItem">Order Item ${x}</label>
                            <input type="text" class="form-control" id="oid_${x}" name="lineItem" value="${value}" readonly>
                        </div>
                    </li>`
            );
        }
    });

    // Create JSON Order Object and send to database
    $("#orderButton").click(function(){
        console.log("Submit myForm");
        $("#orderForm").submit(async function (event) {
            event.preventDefault();
            console.log(($(this)))
            if ($(this).valid()) {
                let po = {}
                let lineItems = []
                $(this).serializeArray().forEach((item) => {
                    if (item.name === "lineItem") {
                        lineItems.push({ "order": item.value })
                    } else {
                        po[item.name] = item.value
                    }
                })
                po['lineItems'] = lineItems
                po['owner_id'] = app.currentUser.id
                console.log(JSON.stringify(po))

                await mongoCollection.insertOne(po).then(success => {
                    $("#alerts").append(`
                            <div class="alert alert-success mx-auto">
                                <strong>Success!</strong> Order successfully submitted!
                                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>`)
                }).catch(err => {
                    console.error(err)
                });
            } else {
                console.log("Form is invalid")
            }
        });
    });
});