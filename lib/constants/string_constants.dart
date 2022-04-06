class RoleConstants {
  static const roleGonnAdoptUser = "gonnaAdoptUser";
  static const roleAdoptPostPetUser = "adoptPostPetUser";
  static const roleMaps = {
    roleAdoptPostPetUser: "Adopt a pet",
    roleGonnAdoptUser: "Let someone else adopt your pet",
  };
}

class ModelConstants {
  static const uuid = "id";
  static const name = "name";
  static const email = "email";
  static const role = "role";
  static const userNID = "nid";
  static const userRating = "rating";
  static const userPhoneNumber = "phoneNumber";
  static const userPassword = "password";
  static const userHouseAddress = "houseAddress";
  static const username = "username";
}

class FireStoreConstants {
  static const userCollection = "Users";
  static const postCollection = "Posts";
  static const reportsComplains = "ReportsComplains";
  static const adoptionPosts = "AdoptionPosts";
  static const bookedUsers = "BookedUsers";
}
