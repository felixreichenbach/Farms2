# MongoDB Stitch Checkout App

This repository contains a Stitch application template "stitch_checkout".
This app consists of a web gui which allows creating new purchase orders and a Stitch trigger, which reacts on inserts into the "orders" collection, transforms them and inserts them into the "po" collection.

## Prerequisites

**Install Stitch CLI:**

https://docs.mongodb.com/stitch/deploy/stitch-cli-reference/#installation

**Create API Key:**

https://docs.atlas.mongodb.com/configure-api-access/#programmatic-api-keys

You will need at least the project owner role.

**Login via CLI:**

```
stitch-cli login --api-key=<PUBLIC-KEY> --private-api-key=<PRIVATE-KEY>
```

## App Import

**Import "./stitch_checkout":**

```
stitch-cli import \
    --path ./stitch_checkout \
    --strategy=replace \
    --include-hosting \
    --yes
```

## App Export

If you change your Stitch app via the MongoDB Atlas webui, you can export it into a template (the "stitch_checkout folder is such a template). Templates allow you to create **new** Stitch apps vie the above mentioned import command.
You may want to change the output folder below.

```
stitch-cli export \
    --app-id=<App ID> \
    --output=./stitch_checkout   \
    --include-hosting \
    --as-template
```
