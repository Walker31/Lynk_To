import express from "express";
import bodyParser from "body-parser";
import { MongoClient } from 'mongodb'; // Import MongoClient from MongoDB package
import connection from './db.cjs'; // Import MySQL connection

const app = express();
const port = 3000;

// Middleware to parse JSON requests
app.use(bodyParser.json());

// Connection URI for MongoDB
const mongoURI = 'mongodb://localhost:27017/'; // Your MongoDB connection URI

// Create a new MongoClient for MongoDB
const mongoClient = new MongoClient(mongoURI);

// Connect to MongoDB and start the server
mongoClient.connect()
  .then(async () => {
    console.log('Connected to MongoDB');

    // Define API endpoint for user creation
    app.post("/create_user", async (req, res) => {
      const { name, rollno, password } = req.body;

      // Check if all required fields are provided
      if (!name || !rollno || !password) {
        return res.status(422).json({ error: "Please fill in all the required fields." });
      }

      try {
        // Access MongoDB database
        const db = mongoClient.db('lynk_to');
        const usersCollection = db.collection('users');
        const messagesCollection= db.collection('messages');

        // Check if a user with the same rollno already exists
        const existingUser = await usersCollection.findOne({ rollno: rollno });

        if (existingUser) {
          return res.status(422).json({ error: "User with this rollno already exists." });
        }

        // Insert the new user into MongoDB
        const newUser = await usersCollection.insertOne({ name, rollno, password });
        console.log('newUser:', newUser);
        if (newUser && newUser.ops && newUser.ops.length > 0) {
          return res.status(201).json(newUser.ops[0]); // Return the inserted user
        } else {
          console.error('Error inserting user:', newUser);
          return res.status(500).json({ error: "Failed to create user." });
        }
      } catch (err) {
        console.error("Error creating user:", err);
        res.status(500).json({ error: "Something went wrong while creating the user." });
      }
    });

    // Route for user login
    app.post("/login", async (req, res) => {
      const { rollno, password } = req.body;

      if (!rollno || !password) {
        return res.status(422).json({ error: "Please provide rollno and password." });
      }

      try {
        // Access MongoDB database
        const db = mongoClient.db('lynk_to');
        const usersCollection = db.collection('users');

        const user = await usersCollection.findOne({ rollno: rollno });

        if (!user) {
          return res.status(404).json({ error: "User not found." });
        }

        if (user.password !== password) {
          return res.status(401).json({ error: "Invalid password." });
        }

        return res.status(200).json({ message: "Login successful." });
      } catch (err) {
        console.error("Error logging in user:", err);
        res.status(500).json({ error: "Something went wrong while logging in." });
      }
    });

    // Define API endpoint to retrieve events from MySQL
    

    app.get('/messages', async (req, res) => {
      try {
        const db = mongoClient.db('lynk_to');
        const messagesCollection = db.collection('messages');

        const messages = await messagesCollection.find().toArray();
        console.log('Fetched messages:', messages);
        return res.status(200).json(messages);
      } catch (err) {
        console.error("Error fetching messages:", err);
        res.status(500).json({ error: "Something went wrong while fetching messages." });
      }
    });
    
    app.post('/post_message', function(req, res, next) {
      var message = {
          rollno: req.body.rollno,
          message: req.body.message,
          timestamp: req.body.timestamp
      };
      const db = mongoClient.db('lynk_to');
      const messagesCollection = db.collection('messages');
      messagesCollection.insertOne(message, function(err, result) {
          if (err) {
            console.error('Error posting message:', err);
            res.status(500).json({ error: 'Error posting message' });
            return;
          }
          console.log('Message has been inserted');
          res.status(201).json({ message: 'Message posted successfully' });
      });
    });

    // Start the server after connecting to MongoDB
    app.listen(port, () => {
      console.log(`Server is running on http://localhost:${port}`);
    });
  })
  .catch(err => {
    console.error('Error connecting to MongoDB:', err);
  });