
// This function keeps track of whether the last number of players selected was one or two players...then routes to correct function for dynamic delete
input_state = "zero";
function reset_page(option) {
  if (input_state === "one" ) {
    reset_one_player();
  } else if (input_state === "two"){
    reset_two_player();
  }
  input_state = option
}


function reset_two_player() {
    // If user changes between one and two players, this function deletes the two name input boxes that resulted from selecting "two player"
  var element = document.getElementById("player1_name");
  element.parentNode.removeChild(element);
  var element = document.getElementById("player2_name");
  element.parentNode.removeChild(element);
  var element = document.getElementById("difficulty");
  element.parentNode.removeChild(element);
}


function reset_one_player() {
  // If user changes between one and two players, this function deletes name input box, difficulty level message, and difficulty dropdown menu
  var element = document.getElementById("player_name");
  element.parentNode.removeChild(element);

  var message = document.getElementById('difficulty_message');
  message.innerHTML = "";

  var element = document.getElementById("difficulty_dropdown");
  element.parentNode.removeChild(element);
}


function onePlayer() {
  // creates the name input box for 1 player
  var player1Input = document.createElement("input");
  player1Input.type = "text";
  player1Input.name = "player1";
  player1Input.id = "player_name";
  player1Input.placeholder = "Player Name";
  player1Input.required = "required";
  player1Input.autofocus = "autofocus";
  document.getElementById('one_player_div').appendChild(player1Input);

  var new_line = document.createElement('p');
  document.getElementById('one_player_div').appendChild(new_line);
}


function twoPlayer() {
  // creates the name input boxes for 2 players
  var player1Input = document.createElement("input");
  player1Input.type = "text";
  player1Input.name = "player1";
  player1Input.id = "player1_name";
  player1Input.placeholder = "Player 1 Name";
  player1Input.required = "required";
  player1Input.autofocus = "autofocus";
  var inputDiv = document.getElementById('two_player_div')
  inputDiv.appendChild(player1Input);

  var player2Input = document.createElement("input");
  player2Input.type = "text";
  player2Input.name = "player2";
  player2Input.id = "player2_name";
  player2Input.placeholder = "Player 2 Name";
  player2Input.required = "required";
  var inputDiv2 = document.getElementById('two_player_div');
  inputDiv2.appendChild(player2Input);

  var difficultyInput = document.createElement("input");
  difficultyInput.type = "hidden";
  difficultyInput.name = "difficulty";
  difficultyInput.value = "placeholder";
  difficultyInput.id = "difficulty";
  var inputDiv3 = document.getElementById('two_player_div');
  inputDiv3.appendChild(difficultyInput);
}


function getDifficulty() {
  // creates a message and difficulty levels dropdown for one player game
  var message = document.getElementById('difficulty_message');
  message.innerHTML = "Select a Difficulty Level";

  var items = ['Random Opponent', 'Sequential Opponent', 'Unbeatable Opponent'];
  var values = ['1', '2', '3'];
  // creates a select element
  var sel = document.createElement('select');
  sel.setAttribute('name', 'difficulty');
  sel.setAttribute('id', 'difficulty_dropdown');
  // sets the options for the select element with items and values arrays
      for (var i = 0; i < 3; i++) {
        var opt = document.createElement('option');
        opt.setAttribute('textContent', items[i]);
        opt.setAttribute('value', values[i]);
        sel.appendChild(opt);
      }
      // append the div with the select element
  var levels = document.getElementById('difficulty_levels');
  levels.appendChild(sel);
  //assign text labels for dropdown menu
  var s = document.getElementById('difficulty_dropdown');
  s.children[0].innerText = "Random Opponent";
  s.children[1].innerText = "Sequential Opponent";
  s.children[2].innerText = "Unbeatable Opponent";

}
