const mongoose = require('mongoose');

const BlogSchema = new mongoose.Schema({
    title: {
        type: String,
        required: [true, "Title must not be empty"],
        maxlength: [200, "Title must not exceed 200 chars"],
        trim: true,
    },
    description: {
        type: String,
        required: [true, "Description must not be empty"],
        trim: true,
    },
    date: {
        type: Date,
        default:Date.now(),
    },
    saved: {
        type: Boolean,
        default:false,
    },
    isNew: {
        type: Boolean,
        default:true,
    },
    username: {
        type: String, // Add this field to store the username of the creator
        required: true,
    },
}, { versionKey: false });

module.exports = mongoose.model('Blog', BlogSchema);
