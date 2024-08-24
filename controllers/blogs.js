const Blog = require('../model/blogs');
const Auth = require('../model/auth');
const bcrypt =require('bcryptjs');
const jwt = require('jsonwebtoken');
const statusUtils = require('../utils/statusUtils');
const appError = require('../utils/appError');

const asyncWrapper = require('../middleware/asyncWrapper');

const createBlog = async (req, res) => {
    try {
      const { title, description } = req.body;
      const username = req.user.username; // Extracted from the token
  
      const newBlog = await Blog.create({
        title,
        description,
        username, // Save the username with the blog
        // other fields...
      });
  
      res.status(201).json({
        success: 'success',
        data: newBlog,
      });
    } catch (error) {
      res.status(500).json({
        message: 'Failed to create blog',
        error: error.message,
      });
    }
  };

const getBlogs = asyncWrapper(
    async (req, res,next) => {
        const query = req.query;
        const limit = query.limit || 10;
        const page = query.page || 1;
        const skip = (page-1) * limit;
        const blogs = await Blog.find({}).limit(limit).skip(skip);
        if(!blogs){
                const e = appError.create(
                    "No blogs found",
                    404,
                    statusUtils.FAIL
                );
                return next(e);
        }
        res.status(200).json({ success: statusUtils.SUCCESS , data: { blogs }});
});

const getSingleBlog = asyncWrapper(
    async (req, res,next) => {

        const blogID = req.params.blogID;
        const blog = await Blog.findById(blogID);
        if (!blog) {
            const e = appError.create(
                "No blog found with that id",
                404,
                statusUtils.FAIL
            );
            return next(e);
        }
        res.status(200).json({ success: statusUtils.SUCCESS , data: { blog }  });
})

const getBlogByTitle = asyncWrapper(async (req, res, next) => {
    const blogTitlePattern = req.query.blogTitle;
  
    // Check if blogTitlePattern is provided
    if (!blogTitlePattern) {
      const e = appError.create(
        "Blog title pattern is required",
        400,
        statusUtils.FAIL
      );
      return next(e);
    }
  
    // Find blogs where the title contains the pattern (case-insensitive)
    const blogs = await Blog.find({ title: { $regex: blogTitlePattern, $options: "i" } });
  
    if (!blogs || blogs.length === 0) {
      const e = appError.create(
        "No blogs found matching that pattern",
        404,
        statusUtils.FAIL
      );
      return next(e);
    }
  
    res.status(200).json({ success: statusUtils.SUCCESS, data: { blogs } });
  });
  
  

  const deleteBlog = asyncWrapper(
    async (req, res, next) => {
      const blogID = req.params.blogID;
      console.log(`Received request to delete blog with ID: ${blogID}`);
      const result = await Blog.deleteOne({ _id: blogID });
      if (result.deletedCount === 0) {
        const e = appError.create("No blog found with that id", 404, statusUtils.FAIL);
        return next(e);
      }
      res.status(200).json({ status: statusUtils.SUCCESS, data: { blog: "null" } });
    }
  );
  

const savedBlog = asyncWrapper(
    async (req, res, next) => {
        const blogID = req.params.blogID.trim();
        const blog = await Blog.findById(blogID);

        if (!blog) {
            const e = appError.create("No blog found with that id", 404, statusUtils.FAIL);
            return next(e);
        }

        const updatedBlog = await Blog.findByIdAndUpdate(blogID, {
            saved: !blog.saved
        }, {
            new: true,
            runValidators: true
        });

        res.status(200).json({
            success: statusUtils.SUCCESS,
            data: { blog: updatedBlog }
        });
    }
);

const getSavedBlogs = asyncWrapper(
    async (req, res, next) => {
        
        const blogs = await Blog.find({saved:"true"});

        if (!blogs) {
            const e = appError.create("No Saved blogs found", 404, statusUtils.FAIL);
            return next(e);
        }

        res.status(200).json({
            success: statusUtils.SUCCESS,
            data: { blogs }
        });
    }
);


const patchBlog = asyncWrapper(
    async (req, res,next) => {
        const blogID = req.params.blogID.trim();
        const blog = await Blog.findByIdAndUpdate(blogID, req.body, {
            new: true,
            runValidators: true,
        });
        if (!blog) {
            const e = appError.create("No blog found with that id",404,statusUtils.FAIL)
            return next(e);
        }
        res.status(200).json({ success: statusUtils.SUCCESS , data: { blog } });
    }
);

module.exports = {
    createBlog,
    getBlogs,
    getSingleBlog,
    deleteBlog,
    patchBlog,
    getBlogByTitle,
    savedBlog,
    getSavedBlogs,
};
