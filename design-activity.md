### Activity: Evaluating Responsibility

As an example, here are two different implementations of a system to keep track of orders in an online shopping cart.

#### Implementation A

```ruby
class CartEntry
  attr_accessor :unit_price, :quantity
  def initialize(unit_price, quantity)
    @unit_price = unit_price
    @quantity = quantity
  end
end

class ShoppingCart
  attr_accessor :entries
  def initialize
    @entries = []
  end
end

class Order
  SALES_TAX = 0.07
  def initialize
    @cart = ShoppingCart.new
  end

  def total_price
    sum = 0
    @cart.entries.each do |entry|
      sum += entry.unit_price * entry.quantity
    end
    return sum + sum * SALES_TAX
  end
end
```

#### Implementation B

```ruby
class CartEntry
  def initialize(unit_price, quantity)
    @unit_price = unit_price
    @quantity = quantity
  end

  def price
    return @unit_price * @quantity
  end
end

class ShoppingCart
  def initialize
    @entries = []
  end

  def price
    sum = 0
    @entries.each do |entry|
      sum += entry.price
    end
    return sum
  end
end

class Order
  SALES_TAX = 0.07
  def initialize
    @cart = ShoppingCart.new
  end

  def total_price
    subtotal = @cart.price
    return subtotal + subtotal * SALES_TAX
  end
end
```

#### Prompts

Once you have read through the above code, add a file to your Hotel project called `design-activity.md`. This file will be submitted with the rest of this exercise. In that file, please respond to the following prompts:

- What classes does each implementation include? Are the lists the same?  
  
  **A has classes for CartEntry, ShoppingCart, and Order.**  
  **B has classes for CartEntry, ShoppingCart, and Order.**  
  **These lists are the same.**  
    
- Write down a sentence to describe each class.  
  
  **CartEntry keeps track of a particular item in our cart.**  
  **ShoppingCart keeps track of all the items in our cart.**  
  **Order keeps track of the price of our order.**
      
- How do the classes relate to each other? It might be helpful to draw a diagram on a whiteboard or piece of paper.  
  
  **When you instantiate an Order object, it creates a ShoppingCart object.**    
  **The ShoppingCart object keeps track of entries, which are CartEntry objects.**  
  **Order can calculate the total price of an order by interacting with ShoppingCart and CartEntry.**  
    
- What **data** does each class store? How (if at all) does this differ between the two implementations?  
    
  **CartEntry stores unit_price and quantity.**  
  **ShoppingCart stores entries.**  
  **Order stores cart.**  
  **This does not differ between the two implementations.**  
    
- What **methods** does each class have? How (if at all) does this differ between the two implementations?  
  
  **A: Order has a total_price method.**  
  **B: CartEntry has a price method.  ShoppingCart has a price method.  Order has a total_price method.**  
  
  **B includes a price method for CartEntry and ShoppingCart.**  
  
- Consider the `Order#total_price` method. In each implementation:  
    - Is logic to compute the price delegated to "lower level" classes like `ShoppingCart` and `CartEntry`, or is it retained in `Order`?  
      
      **A: The logic to compute the price is retained in Order.**  
      **B: The logic to compute the price is delegated to lower level classes (ShoppingCart and CartEntry).**  
      
    - Does `total_price` directly manipulate the instance variables of other classes?  
      
      **A: Yes, the total_price method directly manipulates the instance variables in the CartEntry class.**  
      **B: No, the total_price method relies on a wrapped price method in ShoppingCart, which relies on a wrapped price method in CartEntry.**
      
- If we decide items are cheaper if bought in bulk, how would this change the code? Which implementation is easier to modify?  
  
  **B is probably easier to modify.  We just need to change CartEntry's price method to add a discount based on the quantity.**
    
- Which implementation better adheres to the single responsibility principle?  
  
  **I think B better adheres the single responsibility principle because A has Order taking on too many tasks in order to calculate total_price.**
     
- Bonus question once you've read Metz ch. 3: Which implementation is more loosely coupled?  
    
  **I think B is also more loosely coupled.  For example, Order asks ShoppingCart to get the price of itself, but it doesn't specify how to do it.  Similarly, ShoppingCart asks each CartEntry to return its price, but doesn't get into specifics about the implementation.**

Once you've responded to the prompts, `git add design-activity.md` and `git commit`!

## Revisiting Hotel

Now that we've got you thinking about design, spend some time to revisit the code you wrote for the Hotel project. For each class in your program, ask yourself the following questions:
- What is this class's responsibility?
    - You should be able to describe it in a single sentence.  
      **Room represents a single hotel room.**  
      **RoomBlock represents a block of rooms reserved for a special event.**  
      **Reservation represents a hotel reservation.**  
      **BookingManager manages reservations/block reservations.**  
- Is this class responsible for exactly one thing?  
  **Yes**  
- Does this class take on any responsibility that should be delegated to "lower level" classes?  
  **No**  
- Is there code in other classes that directly manipulates this class's instance variables?  
  **No**  

You might recall writing a file called `refactor.txt`. Take a look at the refactor plans that you wrote, and consider the following:
- How easy is it to follow your own instructions?  
  **My instructions are pretty easy to follow.**  
- Do these refactors improve the clarity of your code?  
  **Yes, I think some of my suggestions will help improve the clarity of my code.**  
- Do you still agree with your previous assessment, or could your refactor be further improved?  
  **Generally, I agree with my previous assessment and I made several changes.  There were a few things I re-evaluated, but ultimately decided against changing them.**

### Activity

Based on the answers to each set of the above questions, identify one place in your Hotel project where a class takes on multiple roles, or directly modifies the attributes of another class. Describe in `design-activity.md` what changes you would need to make to improve this design, and how the resulting design would be an improvement.

If you need inspiration, remember that the [reference implementation](https://github.com/droberts-ada/hotel/tree/dpr/solution) exists.

Then make the changes! Don't forget to take advantage of all the tests you wrote - if they're well structured, they should quickly inform you when your refactoring breaks something.

Once you're satisfied, `git commit` your changes and then `push` them to GitHub. This will automatically update your pull request.

### Summary
**My previous hotel program had four classes: Room, RoomBlock, Reservation, and BookingManager.  After reviewing the code, I am still happy with how I split up the various responsibilities.  I don't think any of my classes directly manipulate another class's instance variables.  After more thought, I also don't think a class for DateRange is necessary.**
  
**In order to improve my code, I did implement several custom errors.  These help identify the specific problem instead of always returning an ArgumentError.  In BookingManager, I also changed the data structures for all_rooms, all_reservations, and all_blocks to hashes instead of arrays, based on feedback I received from my original pull request.**
