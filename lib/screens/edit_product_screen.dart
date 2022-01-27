import 'package:flutter/material.dart';
import 'package:shopping_app/provider/products_provider.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  TextEditingController _imageURLController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      id: DateTime.now().toString(),
      title: '',
      description: '',
      price: 0,
      imageUrl: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageUrlFocusNode.addListener(() {
      if (!_imageUrlFocusNode.hasFocus) setState(() {});
    });
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    context.read<ProductsProvider>().addProduct(_editedProduct);
    print(_editedProduct.id);
    print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.price);
    print(_editedProduct.imageUrl);
  }

  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageURLController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some value';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                onSaved: (newValue) {
                  _editedProduct = Product(
                      title: newValue!,
                      id: _editedProduct.id,
                      price: _editedProduct.price,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl);
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some value';
                  }
                  if (double.tryParse(value!) == null) {
                    return 'Please enter valid number';
                  }
                  if (double.tryParse(value!)! <= 0.0) {
                    return 'Please enter valid Price above 0';
                  }

                  return null;
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      id: _editedProduct.id,
                      price: double.parse(newValue!),
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl);
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),
              TextFormField(
                onSaved: (newValue) {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      id: _editedProduct.id,
                      price: _editedProduct.price,
                      description: newValue!,
                      imageUrl: _editedProduct.imageUrl);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some value';
                  }
                  if (value!.length < 10) {
                    return 'Should be at least 10 characters long';
                  }

                  return null;
                },
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.grey),
                    height: 100,
                    width: 100,
                    //color: Colors.grey,
                    child: _imageURLController.text.isEmpty
                        ? Text(
                            'Enter image url',
                            textAlign: TextAlign.center,
                          )
                        : FittedBox(
                            child: Image.network(
                            _imageURLController.text,
                            fit: BoxFit.cover,
                          )),
                  ),
                  Expanded(
                    child: TextFormField(
                      onSaved: (newValue) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            id: _editedProduct.id,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: newValue!);
                      },
                      controller: _imageURLController,
                      decoration: InputDecoration(labelText: 'Image Url'),
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some value';
                        }
                        if (!value!.startsWith('http') &&
                            !value!.startsWith('https')) {
                          return 'Please enter valid url it should start with http or https';
                        } else if (!value!.endsWith('.png') &&
                            !value!.endsWith('.jpeg') &&
                            !value!.endsWith('.jpg')) {
                          return 'Please enter valid Image';
                        }
                      },
                      onFieldSubmitted: (_) {
                        _saveForm;
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
