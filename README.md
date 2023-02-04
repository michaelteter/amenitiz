# Amenitiz Technical Challenge

This project is a solution to the Amenitiz shopping cart calculation challenge.

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
possible without defining too many abstractions.

Domain models are thin, representing only the data they model.  Operations
on those models are isolated in service modules, where the term "service"
is used in the generic sense rather than as network process.

## App Usage

Launch the command line app with $`ruby cart_app.rb`

The app will provide a menu of commands which provide the functionality described above.

## Tests

Tests are built for the Minitest Ruby test framework.

To run the tests, $`./minitest.sh`

## Products

Products are defined in the file `./assets/products.csv`, which is a simple
comma separated data file (CSV).  An example exists which is based on the original
challenge definition.

The rules can be modified in the CSV file, and the file
can be reloaded in the app via the app menu.

Additional details can be found in the PRODUCTS.md file.

## Discount Rules

Discount rules are defined in the file `./assets/discounts.csv`, which is a simple
comma separated data file (CSV).  An example exists which is based on the original
challenge definition.  

The rules can be modified in the CSV file, and the file
can be reloaded in the app via the app menu.  

Additional details can be found in the DISCOUNTS.md file.

## Caveats

As this is a simple demonstration system, all prices are assumed to
be in the same currency; no currency indicator is necessary.

Were this system expanded to handle multiple currencies, many steps
would need to be taken to allow for currency conversions and representations.
These concerns are beyond the scope of this challenge.

