Important Headers:
- [How to Set The Values](#how-to-set-the-values)
- [Using Macros](#using-macros)

### The Values
All of these can have a suffix of _&lt;suffix&gt;. These can be species IDs, or TRADE_USER_SUFFIX defines.

- `hail_generic` 
	- When the trader hails the person
- `hail_deny` 
	- When the trader denies the hail

- `trade_show_goods` 
	- What the trader says when showing goods
- `trade_no_sell_goods` 
	- What the trader says when disclaiming that he doesnt sell goods

- `what_want` 
	- When showing what items he buys
- `trade_no_goods` 
	- When disclaiming he doesnt buy items

- `compliment_deny` 
	- When denies a compliment
- `compliment_accept` 
	- When accepts a compliment

- `insult_bad` 
	- When he's pissed off at an inuslt
- `insult_good` 
	- When he doesnt mind the insult much

- `pad_empty` 
	- When you try and conduct selling but your pad is empty

- `how_much` 
	- When he appraises the value of item. ITEM = item name, VALUE = amount of cash worth
- `appraise_multiple` 
	- When he appraises the value of multiple items.  VALUE = amount of cash worth

- `trade_found_unwanted` 
	- When there's only items that they dont want on the pad
- `out_of_money` 
	- When the trader's out of money to pay us for stuff
- `doesnt_use_cash` 
	- When he disclaims that he doesnt use cash

- `trade_complete` 
	- Sentence after a successful trade
- `trade_not_enough` 
	- Sentence when the trader rejects a barter offer
- `out_of_stock` 
	- The trader is out of stock on an item the user wants to buy
- `user_no_money` 
	- When the user doesnt have enough money to perform a trade
- `only_deal_in_goods` 
	- When the user tries to sell items for money, but the trader doesnt deal in money

- `bounty_fail_claim` 
	- When the user tries to turn in a bounty, but doesn't meet the requirements

## How to Set The Values

### Actually Using Said Values
For synths, their prefix would be `synth_`, so the full entry would be `synth_bounty_fail_claim`.

For humans, it'd be `human_`, and you can probably put 1+1 together to see where this is going.

All of these entries belong inside a list, so the speech IDs should be `=`'d to a string, being whatever you want the trader to say instead of the default.

`speech = list("human_generic" = "Welcome!")`

And whenever the trader is hailed by a human, it'll say "Welcome!", neat!

### Macros
These are not fancy in the slightest, and only three exist by default. All they serve to do is get the user's name, the trader's name, and the trader's origin.

To use, just type these into a speech string. Case sensitive.

- `MOB`
	- The user's name.
- `TRADER`
	- The trader's name.
- `ORIGIN`
	- The trader's origin. More specifically, their store name.

### Using Macros

So, that generic welcome for humans isn't exactly exciting, so let's spice it up with a bit of personalization!

So, to make this example work, the macros have these values:
- `MOB`
	- `Jo Mama`
- `TRADER`
	- `Toy Shop`
- `ORIGIN`
	- `Child Safe Nukes`

So, we could do something like:

`speech = list("human_generic" = "Hello, MOB! Welcome to ORIGIN, the best TRADER in the sector!")`

Which would translate into:

`Hello, Jo Mama! Welcome to Child Safe Nukes, the best Toy Shop in the sector!`

Dead easy! Now you know everything about trader speech!
