import 'package:flutter/material.dart';
import 'package:gemicates_flutter_app/presentation/widget/login_page.dart';
import 'package:gemicates_flutter_app/provider/auth_provider.dart';
import 'package:gemicates_flutter_app/provider/provider_list_provider.dart';
import 'package:gemicates_flutter_app/services/remote_configuration_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProductListProvider>(context, listen: false).getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final remoteConfigService = RemoteConfigService();


  return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.redAccent,
        title: const Text('Gemicates - Product List', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white,),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
      body: Consumer<ProductListProvider>(
        builder: (context, value, child) {
          // If the loading it true then it will show the circular progressbar
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 10.0, // Space between columns
                mainAxisSpacing: 10.0, // Space between rows
                childAspectRatio: 0.7, // Adjust according to how you want your card layout
              ),
              itemCount: value.productList.length,
              itemBuilder: (context, index) {
                final product = value.productList[index];
                final showDiscount = remoteConfigService.showDiscountPrice;

                final price = product.price ?? 0.0;

                // Calculate the discounted price if applicable
                final discountedPrice = showDiscount && product.discountPercentage != null && product.discountPercentage! > 0
                    ? price * (1 - product.discountPercentage! / 100)
                    : price;

                // Format the price to two decimal places
                final displayPrice = '\$${discountedPrice.toStringAsFixed(2)}';

                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnail Image
                        Expanded(
                          child: Image.network(
                            product.thumbnail ?? "" ,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        const SizedBox(height: 5),

                        // Title
                        Text(
                          product.title ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Category
                        Text(
                          product.category != null ? product.category!.name : "",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 5),

                        // Price and Discount

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              displayPrice,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            if (product.discountPercentage != null && product.discountPercentage! > 0)
                              Text(
                                '${product.discountPercentage}% Off',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        // Rating
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow[600],
                              size: 16,
                            ),
                            Text(
                              product.rating.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
         // final productList = value.productList;
          // return ListView.builder(
          //   itemCount: productList.length,
          //   itemBuilder: (context, index) {
          //     final product = productList[index];
          //     return Container(
          //       decoration: BoxDecoration(
          //         border: Border.all(
          //           width: 0.5,
          //           color: Colors.black12,
          //         ),
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       child: Column(
          //         children: [
          //           Text(product.title ?? ""),
          //
          //         ],
          //       ),
          //     );
          //
          //     // return ListTile(
          //     //   leading: CircleAvatar(
          //     //     child: Text(todo.id.toString()),
          //     //   ),
          //     //   title: Text(
          //     //     todo.title ?? "",
          //     //     style: TextStyle(
          //     //       color: Colors.grey,
          //     //     ),
          //     //   ),
          //     // );
          //   },
          // );
        },
      ),
    );
  }
}
