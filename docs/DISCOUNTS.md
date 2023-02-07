# Discounts

Discounts available to this shopping cart app are defined in the
`./assets/discounts.yaml` file.

This YAML file is structured as such:

```yaml
discounts:
  - code:        GR1-N-for-M
    description: buy {{buy_count}} get {{free_count}} free for green tea
    product_sku: GR1
    rule_name:   BUY_N_GET_M_FREE
    rule_params:
      buy_count:  1
      free_count: 1
```

## Rule Name

Rule name is a text name which maps to built-in logic.

Rule Parameters are any additional data required by the rule.
For example, 

BUY_1_GET_1_FREE requires no parameters

MINIMUM_QTY_ALL_AT_NEW_PRICE requires two parameters: 
1. minimum quantity required to activate the discount
2. new price for all quantity of corresponding item

MINIMUM_QTY_ALL_DISCOUNTED requires two parameters:
1. minimum quantity required to activate the discount
2. discount percentage (ratio expressed as a fraction) which is applied to all quantity of corresponding item

## Rule Params

Rule params are parameters specific to the type of rule being defined.

The type of params appropriate for a given discount depend on the rule,
and that dependency is hard-coded in the implementation of the rule.

For example, a "buy one get one free" rule is generalized as a "buy N get M free",
such that for each unit count N that are in the cart, M count will be discounted
to zero cost.  Therefore, this specific rule requires two rule params:
`buy_count` and `free_count`.  

Other rules may have different params, and the default discounts YAML file 
illustrates the appropriate params for other currently-implemented rules.

## Comments

### Definition File Format

In contrast to the CSV format used for products, YAML was chosen for this definition file 
as it allows better expression of the details of discount rules, since the structure of 
those details can vary depending on the rule.

### Discount vs Discount Rule

The Discount model represents a specific discount, such as the green tea "buy one get one free".
That Discount instance also contains the definition of the general Discount Rule it exercises;
but in the interest of keeping this project small and simple, the Discount Rule was not made
as a separate model.  It really should be...
