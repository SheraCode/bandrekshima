const UserModel = require('../model/user.model');
const jwt = require('jsonwebtoken');

class UserServices {
    static async registerUser(email,password,name, address, telepon) {
        try {
            const createUser = new UserModel({email,password,name, address, telepon});
            return await createUser.save();
        } catch (error) {
            throw error;
        }
    }

    static async getUserByEmail(email){
        try{
            return await UserModel.findOne({email});
        }catch(err){
            console.log(err);
        }
    }
    

    static async checkuser(email) {
        try {
            const user =  await UserModel.findOne({email});
            console.log(user);
            return user;
        } catch (error) {
            throw error
        }
    }



    static async generateAccessToken(tokenData,JWTSecret_Key){
        return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: "1" });
    }
}

module.exports = UserServices;

