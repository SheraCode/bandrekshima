const UserServices = require("../services/user.services");

exports.register = async(req,res,next) => {
    try {
        const {email, password, name, address, telepon} = req.body;

        const successRes = await UserServices.registerUser(email,password, name, address, telepon);

        res.json({
            status: true,
            success: "User Registered Successfuly"
        });
    } catch (error) {
        throw error;
    }
}


exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        const user = await UserServices.checkuser(email);
       
        if (!user) {
            return res.status(404).json({ status: false, error: 'Email tidak ditemukan' });
        }

        const isMatch = await user.comparePassword(password);
        if(isMatch === false) {
            return res.status(401).json({ status: false, error: 'Password tidak benar' });
        }

        let tokenData = {_id:user._id,email:user.email,name:user.name};

        const token1 = await UserServices.generateAccessToken(tokenData,"secret")

        res.status(200).json({
            status: true,
            token: token1
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ status: false, error: 'Terjadi kesalahan saat login' });
    }
}