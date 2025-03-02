# step 4 : Building the first agent 

## google-genai==1.0.0 in requirements.txt 

Not necessary and can be misleading since we are using 
langchain_google_vertexai. 

## Potential errors :

- **GOOGLE_CLOUD_PROJECT environment variable not set**

![step4_1](step4_1.png)

- **How I fixed that** 

![step4_2](step4_2.png)

# step 5 : Building Tools : Conecting Agents to Restful Service and Data

## Feedbacks on the ToolNode : 

Actually the `recommend_book` in book.py is doing 2 things : 

- Simple call to Gemini to get the category 
- Before calling the Restful Service Book-provider 

The call to get the category must be maybe clearly illustrate in the diagram. 
Because, we could assume that we just want the tool to call the Restful service

Also, the implementation on how to interact with VertexAI to generate the category 
could be the same as the one done in the book-provider. Otherwise, it looks like we are trying to do different things.  This would give you consistency across both parts of your system and eliminate the need for that region selection logic.

## Rate Limits problems related to the way of calling the book-provider

 Instead of making multiple separate calls to Vertex AI (which increases the chance of hitting rate limits), we can modify the implementation to make a single API call requesting multiple book recommendations at once.





