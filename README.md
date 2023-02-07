# Amenitiz Technical Challenge

This document describes the goal of the project and high level information.  
Additional and more specific information can be found in the `docs/*.md` files.

## Primary Goal

The goal is to provide a basic shopping cart system where:
- Products can be added to a shopping cart
- Shopping cart total price will be automatically calculated
- Total price can be impacted by special discounts when appropriate

Beyond the basic cart and products, the system allows for special discount
rules to be defined.  These rules are considered each time the cart total
is calculated.

## Additional Goals

This solution demonstrates a service-based architectural approach where
business logic is decoupled from implementation as much as is reasonably
possible without creating too many abstractions.

Domain models are thin, representing only the data they model.  Operations
on those models are isolated in service modules, where the term "service"
is used in the generic sense rather than as network process.

### Reliability

Some functional programming practices are used, such as pure functions and
immutability.  This works well in practice for most Ruby code in general
(beyond this demo), but copy-on-modify can have a significant negative impact
on performance in tight loops and/or when the volume of data being processed
is very large.  With this problem (shopping cart), there is no case where
memory copying would be noticeable, so the concern can be comfortably put 
out of one's mind :).

### Maintainability and Extensibility

This demo implementation attempts to find a good balance of separation of 
concerns and architectural complexity.  An unfamiliar developer should find
it fairly clear how to fix any problems, modify behaviors, or add additional
features.

In particular, the discount rule system provides a pattern that can be followed
to create new types of discounts with relative ease, with two significant
exceptions:
- each product may have only one discount rule which can apply to it
- discounts involving multiple products are not possible without significant changes (probably a complete rearchitecting of the discount system)

## App Usage

Launch the command line app with $`ruby cart_app.rb`

The app will provide a menu of commands which provide the functionality described in the `docs/AMENITIZ_CHALLENGE.md` document.

## Tests

Tests are built for the Minitest Ruby test framework.  Minitest was chosen as it is
lightweight and direct in use (compared to Rspec).

To run the tests, $`./minitest.sh`

Most code is covered by tests.  Two files are completely not covered (cart_app.rb
and display_service.rb) as they are just related to demonstration of the system
and its logic.  All other code representing system and logic are covered save for
a few error cases (which themselves pertain more to the demo rather than the
system logic).

## Products

Products are defined in the file `./assets/products.csv`, which is a simple
comma separated data file (CSV).  An example exists which is based on the original
challenge definition.

The rules can be modified in the CSV file, and the file
can be reloaded in the app via the app menu.

Additional details can be found in the `docs/PRODUCTS.md` file.

## Discount Rules

Discount rules are defined in the file `./assets/discounts.yaml`, which is 
described in the `docs/DISCOUNTS.md` file

## Caveats

### Currency

As this is a simple demonstration system, all prices are assumed to
be in the same currency (Euros).

Were this system expanded to handle multiple currencies, many steps
would need to be taken to allow for currency conversions and representations.
These concerns are beyond the scope of this challenge.

### Floats for Prices

Prices are stored as floats, but in the real world we might use a Currency
class or an integer and corresponding decimal place value.  Further, this
would be included in a localization system, as different currencies can use
different numbers of digits beyond the decimal.

### Error Handling

Error handling is implemented in places where it provides value or is 
beneficial to demonstrating the logic of this system.  However, this demo
is not intended to be bulletproof.

