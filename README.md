## Rails mister cocktails

## Work-flow step by step, use a pattern MVC with a DB (ProgreSQL).

1. Models.
2. Seed the ingredients
3. Routing, Controller, views for Cocktails.
4. Routing, Controller, views for Doses.
5. Design as we go
6. New dose form on the cocktail show page 
7. Select2 on the ingredients dropdown.
8. Add reviews.

1. Deploy Mister Cocktail on Heroku.
2. Add the Image Upload features.

## Background & Objectives I

Now it's time to make a 3-model app with a many to many relationship (`n:n`).
Build a cocktail manager, We want to store our favourite cocktails recipes.

Rails app generation

```bash
install `yarn`
```

# Ubuntu

```bash
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn
```

```bash
cd ~/code/<user.github_nickname>
rails new rails-mister-cocktail --database=postgresql --skip-action-mailbox -T
cd rails-mister-cocktail
```

Create the postgresql database for this new rails app.

```bash
rails db:create
```

Set up git, create a repo on GitHub and push our skeleton.

```bash
git add .
git commit -m "rails new"
gh repo create
git push origin master
```

Import the Wagon's spec to be able to `rake` our progress.

```bash
echo "gem 'rspec-rails', '4.0.0.beta3', group: [ :test ]" >> Gemfile
echo "gem 'rails-controller-testing', group: [ :test ]" >> Gemfile
bundle install
rails db:migrate
rails db:test:prepare
git submodule add https://github.com/XXX/XXXXX-specs.git spec
git add .
git commit -m "Prepare rails app with external specs"
```

Test your code with:

```bash
rails db:migrate RAILS_ENV=test  # If you added a migration
rspec spec/models                # Launch tests
```

Setup your Rails app for Front-end, add Bootstrap and JavaScript dependencies

```bash
yarn add bootstrap jquery popper.js
```

And add the gems we're going to need:

```ruby
# Gemfile
gem 'autoprefixer-rails'
gem 'font-awesome-sass', '~> 5.12.0'
gem 'simple_form'
```

```bash
bundle install
rails generate simple_form:install --bootstrap
```

Download the Le Wagon's stylesheets:

```bash
rm -rf app/assets/stylesheets
curl -L https:///XXX/XXXXX-stylesheets/archive/master.zip > stylesheets.zip
unzip stylesheets.zip -d app/assets && rm stylesheets.zip && mv app/assets/rails-stylesheets-master app/assets/stylesheets
```

To enable Bootstrap responsiveness you will also need to add the following to your `<head>`:

```html
<!-- app/views/layouts/application.html.erb -->

<!DOCTYPE html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

  <!-- [...] -->
```

Finally Import Boostrap JS library using webpack:

```js
// config/webpack/environment.js
const { environment } = require('@rails/webpacker')

// Bootstrap 4 has a dependency over jQuery & Popper.js:
const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
  })
)

module.exports = environment
```
```js
// app/javascript/packs/application.js
import 'bootstrap';
```

## Specs

### 1 - Models

Draw the schema. The tables need are `cocktails`, `ingredients` and `doses`.
Think about the relations between the tables and who is storing the *references*. 😉

![](https://raw.githubusercontent.com/lewagon/fullstack-images/master/rails/mister_cocktail_d1/db.png)

#### Attributes

- A **cocktail** has a name (e.g. `"Mint Julep"`, `"Whiskey Sour"`, `"Mojito"`)
- An **ingredient** has a name (e.g. `"lemon"`, `"ice"`, `"mint leaves"`)
- A **dose** is the amount needed for each ingredient in a cocktail (e.g. the Mojito cocktail needs **6cl** of lemon). So each dose references a cocktail, an    
  ingredient and has a description.

#### Validation

- A cocktail must have a unique name.
- An ingredient must have a unique name.
- A dose must have a description, a cocktail and an ingredient, and [cocktail, ingredient] pairings should be unique.

#### Associations

- A cocktail has many doses
- A cocktail has many ingredients through doses
- An ingredient has many doses
- A dose belongs to an ingredient
- A dose belongs to a cocktail
- You can't delete an ingredient if it is used by at least one cocktail.
- When you delete a cocktail, you should delete associated doses (but not the ingredients as they can be linked to other cocktails).

### 2 - Seed the ingredients

**Our app will not allow users to create ingredients**.
Instead, we will generate a static seed of ingredients to choose from.
Write this seed, for example

```ruby
# db/seeds.rb
Ingredient.create(name: "lemon")
Ingredient.create(name: "ice")
Ingredient.create(name: "mint leaves")
```

**Optional**: have fun and seed real ingredients using [this JSON list](http://www.thecocktaildb.com/api/json/v1/1/list.php?i=list) (with `open-uri` and `json` ruby libs).

### 3 - Routing, Controller, Views for Cocktails

- start with the **route**,
- then start coding the **controller**,
- start coding the **view** and refresh your browser.

When your feature is done (and looks good), move on to the next one and repeat the process!

When you think you're done with the **whole** challenge, use `rake` to make sure it satisfies the specs.

**Features**

Once again, you must have a precise idea of the features of your app in order to build your routes. Here is the list of features:

- A user can see the list of cocktails

```
GET "cocktails"
```

- A user can see the details of a given cocktail, with the dose needed for each ingredient

```
GET "cocktails/42"
```

- A user can create a new cocktail

```
GET "cocktails/new"
POST "cocktails"
```

### 4 - Routing, Controller, Views for Doses

- A user can add a new dose (ingredient/description pair) to an existing cocktail
- Checkout `simple_form` about `f.association` to easily create a select dropdown for our list of ingredients.

```
GET "cocktails/42/doses/new"
POST "cocktails/42/doses"
```

- A user can delete a dose that belongs to an existing cocktail. How can we make a delete link again?

```
DELETE "doses/25"
```

Do we need an `IngredientsController`?

### 5 - Design as we go

Now time to make a nice front-end! Time to play around with CSS! 😊 Can you make it into the Hall of Fame? Go check out [dribbble](https://dribbble.com/) or [onepagelove](https://onepagelove.com/) for inspiration.

![](https://raw.githubusercontent.com/lewagon/fullstack-images/master/rails/mister_cocktail_d1/index_1.png)

Don't forget you can have local images in the `app/assets/images` folder. Or even better, you can ask the user for an `image_url` on submission of the cocktail.

### 6 - New dose form on the cocktail show page (Optional)

Try to put the "New dose form" on the cocktail page, not on a separate page. What changes in the routes? And in the controllers?

### 7 - Select2 on the ingredients dropdown (Optional)

Let's try adding an npm package to our rails app! Let's follow the slides to see how to add `select2` to our ingredients dropdown.

### 8 - Let's add reviews for these awesome cocktails! (Optional)

![](https://raw.githubusercontent.com/lewagon/fullstack-images/master/rails/mister_cocktail_d1/show_2.png)

### 9 - Going further

- Adding a possibility to search cocktails and adding `typed.js` to the search input field.
- Some nice [animate on scroll](https://michalsnik.github.io/aos/) animations for our list of cocktails as we scroll down the index.

## Background & Objectives II

1. Deploy Mister Cocktail on Heroku
2. Add the Image Upload features

### Setup

```bash
cd ~/code/<user.github_nickname>/rails-mister-cocktail
```

If you generated the rails app **without** the `--database` flag, we need to manually migrate this Rails app to Postgresql for heroku.
You can check if the app is configured with postgresql if you have the `pg` gem in the gemfile.

If you need to change the app to postgres, open your Gemfile, find the `sqlite` line. **Replace** it with:

```ruby
# Gemfile
gem "pg"
```

Open the `config/database.yml` file, **delete** everything in it and replace it with:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5

development:
  <<: *default
  database: rails-mister-cocktail_development

test:
  <<: *default
  database: rails-mister-cocktail_test
```

Open your terminal and run:

```bash
rails db:create
rails db:migrate
rails db:seed
```

### Deployment on heroku
```bash
curl https://cli-assets.heroku.com/install.sh | sh  # install on Ubuntu 
```

```bash
heroku login                                        # login
```

```bash
heroku create $YOUR_APP_NAME --region eu            # Create an Heroku app
```

```bash
git remote -v                                       # remote ?    
```

```bash
git push origin master                              # git repo
```

```bash
git push heroku master                              # heroku repo
```

```bash
heroku logs --tail                                  # logs on heroku
```

```bash
heroku run <command>                                # Syntax
```

```bash
heroku run rails db:migrate                         # Run pending migrations in prod
```

```bash
heroku run rails c                                  # Run the production console
```

### Image Upload 

**add a picture** to the `Cocktail` model. The user should be able to upload an image that will then be displayed on the `index` view
of `Cocktail` as a thumbnail. On the `show` view of `Cocktail`, the same image should be displayed, but bigger!

```ruby
# Gemfile
gem 'dotenv-rails', groups: [:development, :test]
```

```bash
bundle install
```

```bash
touch .env
echo '.env*' >> .gitignore
```

```bash
git status                                           # .env should not be there, we don't want to push it to Github.
git add .
git commit -m "Add dotenv - Protect my secret data in .env file"
```

## Cloudinary & Environment

```ruby
# Gemfile
gem 'cloudinary', '~> 1.16.0'
```

```bash
bundle install
```

```bash
# .env
CLOUDINARY_URL=cloudinary://298522699261255:Qa1ZfO4syfbOC-***********************8
```
## Active strorage

Creates two tables in the database to handle the associations between our pictures uploaded on Cloudinary and any Model in our app.

```bash
rails active_storage:install
rails db:migrate
```
```bash
# config/storage.yml
cloudinary:
service: Cloudinary
```

```ruby
# config/environments/development.rb
config.active_storage.service = :cloudinary
```

```ruby
# Production
Replace ``:local`` by ``:cloudinary`` in the config:
```

# config/environments/production.rb

```ruby
config.active_storage.service = ``:cloudinary``
```

```ruby
heroku config:set CLOUDINARY_URL=cloudinary://166....
```

```ruby
heroku config                                           #Check it !
```

### Cocktail Reviews (Optional)

If you're done with the images, try to add an anonymous review system to the cocktails.

