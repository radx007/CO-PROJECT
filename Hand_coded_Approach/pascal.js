const fs = require('fs');

// Keywords, operators, and other types
const keywords = [
  "program", "begin", "end", "var", "const", "type", "procedure", "function",
  "if", "then", "else", "while", "do", "for", "to", "downto", "repeat", "until",
  "case", "of", "write", "writeln", "read", "readln", "integer", "real", "char",
  "boolean", "array", "record", "div", "mod", "and", "or", "not"
];

const operators = [
  ":=", "=", "+", "-", "*", "/", "<>", "<", ">", "<=", ">="
];

const delimiters = [
  ";", ":", ",", ".", "(", ")", "[", "]"
];

// Function to identify token type
function identifyToken(token) {
  if (keywords.includes(token.toLowerCase())) return 'Keyword';
  if (operators.includes(token)) return 'Operator';
  if (delimiters.includes(token)) return 'Delimiter';
  if (/^[+-]?\d+(\.\d+)?([eE][+-]?\d+)?$/.test(token)) {
    return token.includes('.') ? 'RealLiteral' : 'IntegerLiteral';
  }
  if (/^'.*'$/.test(token)) return 'StringLiteral';
  if (token.toLowerCase() === 'true' || token.toLowerCase() === 'false') return 'BooleanLiteral';
  if (/^[A-Za-z][A-Za-z0-9_]*$/.test(token)) return 'Identifier';
  return null;
}

// Helper function to determine value for specific token types
function getTokenValue(token, category) {
  if (['IntegerLiteral', 'RealLiteral', 'StringLiteral', 'BooleanLiteral'].includes(category)) {
    return token; // Keep the actual token value for these categories
  }
  return ''; // Return empty for all other categories
}

// Lexer function
function lexer(input) {
  let tokens = [];
  let errors = [];
  let currentToken = '';
  let currentChar;
  let inString = false;
  let inCurlyBraceComment = false;
  let inParenthesisComment = false;
  let lineNumber = 1; // Track line numbers
  let nestedCurlyComments = 0;
  let nestedParenthesisComments = 0;

  for (let i = 0; i < input.length; i++) {
    currentChar = input[i];

    // Increment line number on newline
    if (currentChar === '\n') {
      lineNumber++;
    }

    // Handle curly brace comments
    if (inCurlyBraceComment) {
      if (currentChar === '{') {
        nestedCurlyComments++;
      } else if (currentChar === '}') {
        nestedCurlyComments--;
        if (nestedCurlyComments === 0) {
          inCurlyBraceComment = false;
        }
      }
      continue;
    }

    // Handle parenthesis-asterisk comments
    if (inParenthesisComment) {
      if (currentChar === '(' && input[i + 1] === '*') {
        nestedParenthesisComments++;
        i++;
      } else if (currentChar === '*' && input[i + 1] === ')') {
        nestedParenthesisComments--;
        i++;
        if (nestedParenthesisComments === 0) {
          inParenthesisComment = false;
        }
      }
      continue;
    }

    // Detect start of curly brace comment
    if (currentChar === '{') {
      inCurlyBraceComment = true;
      nestedCurlyComments++;
      continue;
    }

    // Detect start of parenthesis-asterisk comment
    if (currentChar === '(' && input[i + 1] === '*') {
      inParenthesisComment = true;
      nestedParenthesisComments++;
      i++;
      continue;
    }

    // Handle whitespaces and process current token
    if (/\s/.test(currentChar) && !inString) {
      processToken();
    } else if (currentChar === "'" && !inString) {
      inString = true; // Start of string literal
      currentToken += currentChar;
    } else if (currentChar === "'" && inString) {
      currentToken += currentChar; // End of string literal
      tokens.push({
        lexeme: currentToken,
        category: 'StringLiteral',
        value: getTokenValue(currentToken, 'StringLiteral')
      });
      currentToken = '';
      inString = false;
    } else if (currentChar === ":" && input[i + 1] === "=" && !inString) {
      processToken();
      tokens.push({ lexeme: ":=", category: 'Operator', value: '' });
      i++; // Skip '=' character
    } else if ((delimiters.includes(currentChar) || operators.includes(currentChar)) && !inString) {
      processToken();
      tokens.push({ lexeme: currentChar, category: 'Delimiter', value: '' });
    } else {
      currentToken += currentChar;
    }
  }

  // Process any remaining token
  processToken();

  // Helper function to process and categorize the current token
  function processToken() {
    if (currentToken) {
      const category = identifyToken(currentToken);
      if (category) {
        tokens.push({
          lexeme: currentToken,
          category,
          value: getTokenValue(currentToken, category)
        });
      } else {
        errors.push(`Lexical Error, Line ${lineNumber}: "${currentToken}" Unrecognized character`);
      }
      currentToken = '';
    }
  }

  // Check for unclosed comments
  if (nestedCurlyComments > 0) {
    errors.push(`Lexical Error: Unclosed curly brace comment detected.`);
  }
  if (nestedParenthesisComments > 0) {
    errors.push(`Lexical Error: Unclosed parenthesis-asterisk comment detected.`);
  }

  return { tokens, errors };
}

// Read input and process it
const inputFilePath = 'input.txt'; // Specify your input Pascal file here
const outputFilePath = 'output.txt'; // Specify your output file here

fs.readFile(inputFilePath, 'utf8', (err, data) => {
  if (err) {
    console.error('Error reading input file:', err);
    return;
  }

  const { tokens, errors } = lexer(data);

  // Format the tokens as a table
  let output = 'Token Table:\n';
  output += '| Lexeme          | Category        | Value      |\n';
  output += '|-----------------|-----------------|------------|\n';

  tokens.forEach(token => {
    output += `| ${token.lexeme.padEnd(15)} | ${token.category.padEnd(15)} | ${token.value.padEnd(10)} |\n`;
  });

  // Append errors to the output
  if (errors.length > 0) {
    output += '\nError Table:\n';
    errors.forEach(error => {
      output += `${error}\n`;
    });
  }

  // Write to the output file
  fs.writeFile(outputFilePath, output, (err) => {
    if (err) {
      console.error('Error writing output file:', err);
    } else {
      console.log('Lexing completed. Output written to', outputFilePath);
    }
  });
});
