bitmanic-grunt
==============

A static site generator boilerplate and build script. Made possible by Grunt, Bower, Bootstrap, Assemble, Handlebars, Sass, Coffeescript, and LiveReload, among others.

---

## Quick Start

This project requires Grunt. Navigate to the project directory on the command line and type `grunt`. This fires up the `grunt server` command, which starts a local development server at http://localhost:4000.

Now you can start coding!

---

## Development

Project development happens in the `./source` directory, which should look something like this:

```
assets/
  css/
    _bootstrap.sass
    styles.sass
  fonts/
  img/
  js/
    scripts.coffee
layouts/
  default.html
partials/
  footer.html
  header.html
index.html
```

### HTML

We're using Assemble to add layout/partial support to HTML files, and Assemble's default rendering engine is Handlebars. We're using Handlebars here, but we're using the `.html` file extension to be more obvious about which files are meant to generate pages.

HTML pages can store data in YAML Front Matter, which is also accessible in the page using Handlebars. Example:

```handlebars
---
title: YAML Front Matter
description: A very simple way to add structured data to a page.
---

<h1>{{ title }}</h1>
<p>{{ description }}</p>
Page content here...
```

### Stylesheets

We're using Sass and Compass to style the project. We're also building on top of Bootstrap, but we're using a custom stylesheet to include only the components of Bootstrap that we want to use. This keeps the generated CSS as slim as possible. To enable/disable Bootstrap component styles, edit `source/assets/css/_bootstrap.sass`. The following excerpt of said file demonstrates the disabling of Bootstrap's Glyphicons:

```sass
// Core variables and mixins
@import "bootstrap-sass-official/vendor/assets/stylesheets/bootstrap/_variables.scss"
@import "bootstrap-sass-official/vendor/assets/stylesheets/bootstrap/_mixins.scss"

// Reset and dependencies
@import "bootstrap-sass-official/vendor/assets/stylesheets/bootstrap/_normalize.scss"
@import "bootstrap-sass-official/vendor/assets/stylesheets/bootstrap/_print.scss"
// @import "bootstrap-sass-official/vendor/assets/stylesheets/bootstrap/_glyphicons.scss"
```

### Javascripts

We're using CoffeeScript and namespacing to write JavaScripts for the project. Namespacing allows our CoffeeScript files to be wrapped in anonymous functions but still retain accessibility. Usage:

```coffeescript
# Usage:
#
namespace 'Hello.World', (exports) ->
  # `exports` is where you attach namespace members
  exports.hi = -> console.log 'Hi World!'

namespace 'Say.Hello', (exports, top) ->
  # `top` is a reference to the main namespace
  exports.fn = -> top.Hello.World.hi()

Say.Hello.fn()  # prints 'Hi World!'
```
