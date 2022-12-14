# Overview

The purpose of this Integration guide is to serve as technical documentation for merchants who wish to integrate the Geidea Payment plugin for Flutter so that they can use Payment Gateway services in their application.

This guide describes the functionality and APIs provided by the plugin and different approaches to integrating the plugin and customizing it.


# Integration

Please install the prerequisites first, then you can either integrate the plugin using

1. **Simple** integration – 	The plugin hosts the entire UI flow and performs all transactions. A “turnkey” solution that requires minimal setup. You simply call a method to start the Payment flow and then receive your Order after everything is ready.
2. **Custom** integration – the Merchant app hosts the entire UI flow (payment form, authentication) and performs all transactions by calling the Direct APIs through the plugin.


## Prerequisites

1 - Add the following to your **<code>pubspec.yaml</code></strong> file under dependencies


```
     geideapay:
    	git:
      	url: https://github.com/GeideaSolutions/geideapay.git
      	ref: main # branch name
```


2 - Change the **<code>minSdkVersion </code></strong>in  android/app/build.gradle file to be <strong>19</strong>


```
     android {
       defaultConfig {
     	minSdkVersion 19
       }
     }

```



1. Simple integration

   1 - add the following imports


    ```
    import 'package:geideapay/common/geidea.dart';
    import 'package:geideapay/widgets/checkout/checkout_options.dart';
    import 'package:geideapay/api/response/order_api_response.dart';
    ```



    2 - Define an instance of the plugin


    ```
     final plugin = GeideapayPlugin();
    ```



    3 - Call the initialize function for the plugin and provide it with the 


    ```
     @override
      void initState() {
    plugin.initialize(publicKey: YourGeideaPublicKey, apiPassword: YourGeideaApiPassword);
    	super.initState();
      }
    ```



    4 - Create a **<code>CheckoutOptions</code></strong> object. The fields of this object are defined in the following table
    5 - Call the checkout function from the plugin instance


```
       	OrderApiResponse response =
      	await plugin.checkout(
          	context: context, checkoutOptions: checkoutOptions);
      	print('Response = $response');
```
