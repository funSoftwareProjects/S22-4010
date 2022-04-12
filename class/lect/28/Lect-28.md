

<style>
.pagebreak { page-break-before: always; }
.half { height: 200px; }
</style>
<style>
.pagebreak { page-break-before: always; }
.half { height: 200px; }
.markdown-body {
	font-size: 12px;
}
.markdown-body td {
	font-size: 12px;
}
</style>


# Lecture 28 - Token Economics, Vesting Contract

Let say you create a big pile of tokens.  Say 1 billion.
How do you determine the value of this big pile.

Let's look at international coffee market.

Coffee is the 2nd most internationally traded commodity.

There are 11.06 million bags of coffee traded last year.  The bags are 100LB.
The price is currently running at 204.20 cents/lb.  This means that a bag of
coffee is about $2000 per bag.

Note: There are several sizes of bags as the amount packaged varies
by the region where is was grown. Typical burlap coffee bags of
green coffee beans run from 100 pounds (45.6 kg) from Hawaii &
Puerto Rico to 154 pounds (70 kg) from Columbia or Bolivia. Asian
and African bags tend to average 50 & 60 kg, respectively, and bags
from Latin America usually run 152 pounds (69 kg).

There is demand for tractability and environmental protection in the market.
Consumers will pay more for quality.

In many parts of the world fair markets do not exists for coffee.  There is lots
of child labor and exploitation.  

Coffee is also under tremendous pressure due to 'leaf blight'.

Fake sales of higher quality coffee (Kona for example) are rampant.  The reason
for this is an actual bag of Kona sells for around $4500 per bag, v.s. the 2000
a bag average.

Let's say you want to disintermediate the entire world coffee market.
Establish tracking.  Pay farmers in "tokens" for good environmental practices.
Remove child labor and control the worlds coffee supply.

Start with creating a "coffee token".  This is going to be the monitory traded
unit of value.  You are going to need a lot of this.  It is the worlds 2nd 
largest internationally traded item.

Add an ERC-721 based NFT token for tracking bags of coffee.  Each grower has the
ability to sign and mint NFTs for the bags that they ship.  Each grower receives
payment for the bags in the VvvToken.

Add an Air-Tag based location tracking to every shipment of coffee.

Add bag-tractability, to end-consumer tractability.  This is part-supply-chain,
part economics.  Use the secure RFIDs we talked about last time for bags.  Used
digitally signed QR codes for smaller amounts - like a cup of coffee or a retail
1LB bag of coffee.  The digitally signed data is the combination of a URL to 
the tracking site and a digitally signed chunk of data.

```
http://vvvCoffeeTrack.com/track?vendor_id=287292728227827287287382&track_id=0x4782afd2a....
```

Each URL is signed by the vendor that is supplying the data and the track_id is a
digitally signed token using the vendors private key to sing, the vendors public 
key to validate.  (these are essentially JWT tokens).

The base data for the NFT / tracking a bag can now include where and when the bag
was harvested.  The environmental conditions at harvest.  The storage conditions
after harvest.

Each tracking "scan" of the NFC attached to a bag - start of shipping, shipped to,
received, head in whorehouse gets added as additional data to the NFT.   This allows
each entity in the chain to have visibility into where the coffee is at.

An "Air-Tag" is added to a shipment.  This reports the position of the shipment
every 3 minutes.  This data is matched with the set of NFTs in the shipment.

This is "golden" data for preventing hijacking of coffee shipments.   Last year
coffee was the 2nd most hijacked product.  (Tobacco is #1).  Think about it
55000 LB of coffee at $2.00 a LB is $110,000.00 in a single container.  
That is if you pay in $dollars - how about in traceable tokens.  Suddenly
the value of the tokens becomes real.

Now suppose that somebody is trying to buy Arabica beans and sell them as
Kona.  This becomes instantly obvious, we can track where the sale is - who
is doing it.  This drives up the price of Kona - and makes it much more valuable.

The end consumers will pay more for "environmentally" traceable products.  In
tracking proteins (beef, pork, chicken) we have seen that they will pay 20-30%
more for the this.  So when we convert from bags of beans tracked with a more
expensive NFC communication chip to a 1lb or 2lb bag - we switch over to a
QR code with a URL in it.

## Now the Token Economics

Let's say you start with 100,000,000,000 (yes 100 billion in tokens).
For tracked coffee you purchase in tokens that is then converted to an
account where the grower tags and traces the coffee - and can spend the
revenue via something like a MasterCard tied to a blockchain (bitcoin,eth etc) 
account.   Instead of payment in net-90 as most growers are, they get the
payment upon shipment.

What you want is for your "token" to appreciate in value ( a deflationary
currency ) but not so fast that everybody herds it.

There are 3 ways to get "deflation"

1. Expand the market faster than the rate at which you are releasing new tokens.
2. Purchase tokens with dollars to decrease the supply.
3. Get people to hoard the tuns (2 systems)
	- Deflationary
	- Staking

Let's take a look at each.

Now remember as a business you are sitting on a PILE of tokens.  If you can get
it to be deflationary at 2% above inflation you are making a TON of money.

Adding you in this is the fact that coffee is a scarce commodity and getting
more scarce over time.  This is due to the leaf blight problem.  

Now with the tokens in the system you can value add at each level.  The shipping
can be payed out immediately in tokens.   Each bag can be tracked to the exact
tokens that were used to pay for this step.    The middlemen now need to buy
tokens to purchase the coffee at middle steps.   This converts more cash to 
tokens.   Each of these can be tracked.  The NFC-per bag can now be matched to
the tokens used to pay for it.     When a roosting operation converts form NFC
tags to QR-Code-Signed tags - it issues new NFTs for each QR code, signers it
and maintains the track of custody.

The end consumer can now scan a bag of coffee and get the entire history on that
bag.  In terms of marketing every bag can now contain the "story" of the farmer
that raised the beans.  That "story" is the marketing end - and how you can
charge more for the end product.

At every step the buy/sell of the VvvTokens drives demand for the tokens.
This eliminates all of the dollar/exchange costs and the risk of different
currencies in the supply chain.  That is another benefit.















