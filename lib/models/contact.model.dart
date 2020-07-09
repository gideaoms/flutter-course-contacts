class ContactModel {
  int id = 0;
  String name = "";
  String email = "";
  String phone = "";
  String image = "assets/images/profile-picture.png";
  String addressLine1 = "";
  String addressLine2 = "";
  String latLng = "";

  ContactModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.addressLine1,
    this.addressLine2,
    this.latLng,
  });

  ContactModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    latLng = json['latLng'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'image': image,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'latLng': latLng,
    };
  }
}
