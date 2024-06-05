# pull official base image
FROM node:17-alpine

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
RUN npm install 
#--silent
RUN npm install react-scripts@5.0.1 -g 

# add app
COPY . ./

# Expose port
EXPOSE 3000

# start app
CMD ["npm","start"]
