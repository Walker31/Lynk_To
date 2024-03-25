import express from "express";
import bodyParser from "body-parser";
import { MongoClient } from 'mongodb';
const cors = require('cors');
import connection from './db.cjs'; // Assuming this file contains MySQL connection setup

const app = express();
const port = 3000;
app.use(cors());


app.use(bodyParser.json());

const mongoURI = 'mongodb://localhost:27017/';
const mongoClient = new MongoClient(mongoURI);

mongoClient.connect()
  .then(async () => {
    console.log('Connected to MongoDB');
    const db = mongoClient.db('lynk_to');
    const usersCollection = db.collection('users');
    const messagesCollection = db.collection('messages');

    app.post("/create_user", async (req, res) => {
      const { name, rollno, password } = req.body;

      if (!name || !rollno || !password) {
        return res.status(422).json({ error: "Please fill in all the required fields." });
      }

      try {
        const existingUser = await usersCollection.findOne({ rollno: rollno });

        if (existingUser) {
          return res.status(422).json({ error: "User with this rollno already exists." });
        }

        const newUser = await usersCollection.insertOne({ name, rollno, password });

        if (newUser && newUser.ops && newUser.ops.length > 0) {
          return res.status(201).json(newUser.ops[0]);
        } else {
          console.error('Error inserting user:', newUser);
          return res.status(500).json({ error: "Failed to create user." });
        }
      } catch (err) {
        console.error("Error creating user:", err);
        res.status(500).json({ error: "Something went wrong while creating the user." });
      }
    });

    app.post("/login", async (req, res) => {
      const { rollno, password } = req.body;

      if (!rollno || !password) {
        return res.status(422).json({ error: "Please provide rollno and password." });
      }

      try {
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

    app.get('/messages', async (req, res) => {
      try {
        const messages = await messagesCollection.find().toArray();
        console.log('Fetched messages:', messages);
        return res.status(200).json(messages);
      } catch (err) {
        console.error("Error fetching messages:", err);
        res.status(500).json({ error: "Something went wrong while fetching messages." });
      }
    });
    
    const http = require('http');

    app.post('/post_message', async (req, res) => {
      const { rollno, message, timestamp } = req.body;

      if (!rollno || !message || !timestamp) {
        return res.status(422).json({ error: "Please provide rollno, message, and timestamp." });
      }

      try {
        const newMessage = await messagesCollection.insertOne({ rollno, message, timestamp });
        console.log('Message has been inserted');
        res.status(201).json({ message: 'Message posted successfully' });
      } catch (err) {
        console.error('Error posting message:', err);
        res.status(500).json({ error: 'Error posting message' });
      }
    });

    app.get('/events', (req, res) => {
      const { event_date, user_id } = req.query;
    
      if (!event_date || !user_id) {
        return res.status(400).json({ error: 'Both event_date and user_id parameters are required.' });
      }
    
      const query = `
        SELECT s.subject_name, e.event_type, e.event_time
        FROM events e
        JOIN registrations r ON e.subject_code = r.subject_id
        JOIN subjects s ON e.subject_code = s.subject_code
        WHERE r.user_id = ?
        AND e.event_date = ?;`;
    
      connection.query(query, [user_id, event_date], (err, result) => {
        if (err) {
          console.error('Error fetching events:', err);
          return res.status(500).json({ error: 'Error fetching events' });
        }
        res.json(result);
      });
    });

    app.listen(port, () => {
      console.log(`Server is running on http://localhost:${port}`);
    });
  }).catch(err => {
    console.error('Error connecting to MongoDB:', err);
  });


  app.post('/script', async (req, res) => {
    const { message } = req.body;
  
    // Validate the incoming data
    if (!message) {
      return res.status(422).json({ error: 'Please provide a message.' });
    }
  
    // Construct the data to be sent in the POST request
    const postData = JSON.stringify({
      query: message // Modify this with the actual query you want to send
    });
  
    // Define the options for the HTTP POST request
    const options = {
      hostname: '127.0.0.1',
      port: 5000,
      path: '/query',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': postData.length
      }
    };
  
    // Create the HTTP request object
    const httpRequest = http.request(options, (httpResponse) => {
      let data = '';
      httpResponse.on('data', (chunk) => {
        data += chunk;
      });
      httpResponse.on('end', () => {
        console.log('Query sent successfully:', data);
        res.status(201).json({ message: 'Message posted successfully' });
      });
    });
  
    // Handle errors
    httpRequest.on('error', (error) => {
      console.error('Error sending query:', error);
      res.status(500).json({ error: 'Error sending query' });
    });
  
    // Write the data to the request body
    httpRequest.write(postData);
    httpRequest.end();
  });
  
