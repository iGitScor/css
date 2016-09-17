# CSS / Preprocessor Styleguide

## Table of Contents

  1. [Terminology](#terminology)
    - [Rule Declaration](#rule-declaration)
    - [Selectors](#selectors)
    - [Properties](#properties)
  1. [CSS](#css)
    - [Formatting](#formatting)
    - [ID Selectors](#id-selectors)
    - [JavaScript hooks](#javascript-hooks)
  1. [Preprocessor](#preprocessor)
    - [Syntax](#syntax)
    - [Ordering](#ordering-of-property-declarations)
    - [Variables](#variables)
    - [Mixins](#mixins)
    - [Nested selectors](#nested-selectors)
  1. [CSS architecture](#css-architecture)
    - [Settings](#settings)
    - [Web components](#web-components)

## Terminology

### Rule declaration

A “rule declaration” is the name given to a selector (or a group of selectors) with an accompanying group of properties. Here's an example:

```css
.example {
  color: #dfdfdf;
}
```

### Selectors

In a rule declaration, “selectors” are the bits that determine which elements in the DOM tree will be styled by the defined properties. Selectors can match HTML elements, as well as an element's class, ID, or any of its attributes. Here are some examples of selectors:

```css
.my-element-class {
  /* ... */
}

[aria-hidden] {
  /* ... */
}
```

### Properties

Finally, properties are what give the selected elements of a rule declaration their style. Properties are key-value pairs, and a rule declaration can contain one or more property declarations. Property declarations look like this:

```css
/* some selector */ {
  background: #f1f1f1;
  color: #333;
}
```

## CSS

### Formatting

** _Rules:_ **

```yml
# Line Spacing
one-declaration-per-line: 1
empty-line-between-blocks: 1
single-line-per-selector: 1

no-ids: 1

# Nesting
force-attribute-nesting: 0
force-element-nesting: 1
force-pseudo-nesting: 0

# Inner Spacing
space-after-comma: 1
space-before-colon: 1
space-after-colon: 1
space-before-brace: 1
space-before-bang: 1
space-after-bang: 1
space-between-parens: 1
# Some CSS tricks need no space
space-around-operator: 0
```

* Use soft tabs (2 spaces by tabulation) for indentation
* Prefer dashes over camelCasing in class names.
* Do not use ID selectors
* When using multiple selectors in a rule declaration, give each selector its own line.
* Put a space before the opening brace `{` in rule declarations
* In properties, put a space after, but not before, the `:` character.
* Put closing braces `}` of rule declarations on a new line
* Put blank lines between rule declarations

**Bad**

```css
.avatar{
    border-radius:50%;
    border:2px solid white; }

.no, .nope, .not_good {
}

#selector-with-id {
}
```

**Good**

```css
.avatar {
  border-radius: 50%;
  border: 2px solid #fff;
}

.one,
.selector,
.per-line {
}
```

### ID selectors

While it is possible to select elements by ID in CSS, it should generally be considered an anti-pattern. ID selectors introduce an unnecessarily high level of [specificity](https://developer.mozilla.org/en-US/docs/Web/CSS/Specificity) to your rule declarations, and they are not reusable.

For more on this subject, read [CSS Wizardry's article](http://csswizardry.com/2014/07/hacks-for-dealing-with-specificity/) on dealing with specificity.

### JavaScript hooks

Avoid binding to the same class in both your CSS and JavaScript. Conflating the two often leads to, at a minimum, time wasted during refactoring when a developer must cross-reference each class they are changing, and at its worst, developers being afraid to make changes for fear of breaking functionality.

I recommend creating JavaScript-specific attributes to bind to, prefixed with data for compatibility `data-`:

```html
<button class="btn btn-primary" data-toggle>Display/Hide content</button>
```

## Preprocessor

### Syntax

* Use the `.scss` syntax, never the original `.sass` syntax
* Order your regular CSS and `@include` declarations logically (see below)

### Ordering of property declarations

1. Property declarations

    List all standard property declarations, anything that isn't an `@include` or a nested selector.

    ```scss
    .btn-valid {
      background: #0f0;
      font-weight: bold;
      // ...
    }
    ```

2. `@include` declarations

    ** _Rule:_ **

    ```yml
    # Mixins
    mixins-before-declarations: 0
    ```

    Grouping `@include`s at the end makes it easier to read the entire selector.

    ```scss
    .btn-valid {
      background: #0f0;
      font-weight: bold;
      @include transition(background 0.5s ease);
      // ...
    }
    ```

3. `@extend` declarations

    ** _Rules:_ **

    ```yml
    # Extends
    extends-before-mixins: 1
    extends-before-declarations: 1
    placeholder-in-extend: 1
    ```

    Grouping `@extend` at the start makes it safier to herit properties from other objects or elements. Prefer use of placeholder.

    ```scss
    .notification {
      @extend %box;
      background: #0f0;
      // ...
    }
    ```

4. Nested selectors

    Nested selectors, _if necessary_, go last, and nothing goes after them. Add whitespace between your rule declarations and nested selectors, as well as between adjacent nested selectors. Apply the same guidelines as above to your nested selectors.

    ```scss
    .btn {
      background: #0f0;

      .icon {
        color: #fff;
      }
    }
    ```

### Variables

Prefer dash-cased variable names (e.g. `$my-variable`) over camelCased or snake_cased variable names.

Always use hexadecimal values for color variables.

```scss
$primary-color: #f4ac13;
```

Specify a default value in a component if it depends on a setting variable (e.g. grid generation with breakpoints variable)

```scss
$accent-color: #f4ac13 !default;
```

### Mixins

Mixins should be used to DRY up your code, add clarity, or abstract complexity--in much the same way as well-named functions. Mixins that accept no arguments can be useful for this, but note that if you are not compressing your payload (e.g. gzip), this may contribute to unnecessary code duplication in the resulting styles.

### Nested selectors

** _Rules:_ **

```yml
nesting-depth:
  - 1
  - max-depth: 3
```

**Do not nest selectors more than three levels deep!**

```scss
.page-container {
  .content {
    .card {
      // STOP!
    }
  }
}
```

When selectors become this long, you're likely writing CSS that is:

* Strongly coupled to the HTML (fragile) *—OR—*
* Overly specific (powerful) *—OR—*
* Not reusable


Again: **never nest ID selectors!**

If you must use an ID selector in the first place (and you should really try not to), they should never be nested. If you find yourself doing this, you need to revisit your markup, or figure out why such strong specificity is needed. If you are writing well formed HTML and CSS, you should **never** need to do this.

## CSS architecture

After multiple kind of works, the same conclusion is done, never let the CSS be a complex structure.
For that, the recommendation is to split your styles in several files.

A good approach is the ITCSS' one.

### Settings

If you use preprocessors or modern css with variable, you **must** declare some variables in a specific place.
In this file, you've to specify colors, spacing, fonts, responsive breakpoints. Even if the project is small, it's a good practice to
externalize configuration.

Also, you have to externalize mixins and functions you'll be susceptible to use in components/objects.

### Web components

The web component pattern is not only a frontend development pattern, it can be used in css architecture.
More the CSS' structure is dry, simple, more the CSS is maintainable.

* Elements - standard markups' default style
* Object - no style scaffolding objects _(using spacing setting)_
* Component - stylized components _(using color settings)_
* Trumps - css helpers _(e.g: text alignment)_
