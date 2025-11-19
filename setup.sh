#!/bin/bash

echo "🐾 PawMatch Setup Script"
echo "========================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed. Please install Node.js 18+ first.${NC}"
    echo "Visit: https://nodejs.org/"
    exit 1
fi

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python 3 is not installed. Please install Python 3.8+ first.${NC}"
    echo "Visit: https://www.python.org/"
    exit 1
fi

echo -e "${GREEN}✅ Prerequisites checked${NC}"
echo ""

# Install Node.js dependencies
echo -e "${YELLOW}📦 Installing Node.js dependencies...${NC}"
npm run install-all

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to install Node.js dependencies${NC}"
    exit 1
fi

# Install Python dependencies
echo ""
echo -e "${YELLOW}🐍 Installing Python dependencies...${NC}"
cd server
pip3 install -r requirements.txt

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to install Python dependencies${NC}"
    echo -e "${YELLOW}Try: pip3 install --user -r requirements.txt${NC}"
    exit 1
fi

cd ..

# Create .env files if they don't exist
echo ""
echo -e "${YELLOW}⚙️  Setting up environment files...${NC}"

if [ ! -f server/.env ]; then
    cat > server/.env << EOL
PORT=3001
MONGODB_URI=mongodb://localhost:27017/pawmatch
JWT_SECRET=change-this-to-a-secure-random-string-$(date +%s)
FACE_VERIFICATION_URL=http://localhost:5001
EOL
    echo -e "${GREEN}✅ Created server/.env${NC}"
else
    echo -e "${YELLOW}⚠️  server/.env already exists, skipping...${NC}"
fi

if [ ! -f client/.env ]; then
    cat > client/.env << EOL
VITE_API_URL=http://localhost:3001/api
EOL
    echo -e "${GREEN}✅ Created client/.env${NC}"
else
    echo -e "${YELLOW}⚠️  client/.env already exists, skipping...${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Setup Complete!${NC}"
echo ""
echo "To start the application:"
echo -e "${YELLOW}1. Make sure MongoDB is running${NC}"
echo "   mongod"
echo ""
echo -e "${YELLOW}2. Start the face verification service:${NC}"
echo "   cd server && python3 face_verification.py"
echo ""
echo -e "${YELLOW}3. In a new terminal, start the backend:${NC}"
echo "   cd server && npm run dev"
echo ""
echo -e "${YELLOW}4. In another terminal, start the frontend:${NC}"
echo "   cd client && npm run dev"
echo ""
echo -e "${YELLOW}Or simply run from the root directory:${NC}"
echo "   npm run dev"
echo ""
echo -e "${GREEN}The app will be available at: http://localhost:5173${NC}"
echo ""
echo "Happy matching! 🐾❤️"
