<script lang="ts">
    import Apps from "@components/shared/Apps.svelte";
    import { fetchNui } from "@utils/eventHandler";
    let topData = {
      title: "File Explorer",
      background: "#1c1b22",
      blur: true,
      blurstrength: 15,
      color: "#1b1b1b",
    };
</script>

<Apps topdata={topData} appname="fileexplorer">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css" integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <div class = "apps">
        <div class = "login-page">
            <div class = "admin-required">Administrator permission required. <br>Please log in using an admin account.</div>
            <div class = "login-container">
                <div class = "username">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username">
                </div>
                <div class = "password">
                    <label for="password">Password</label>
                    <input type="text" id="password" name="password">
                    <i class="fa-solid fa-user"></i>
                </div>
            </div>
        </div>
    </div>
</Apps>

<style>
  .apps {
    overflow: hidden;
    height: 100%;
  }
  .admin-required {
    font-size: 20px;
    text-align: center;
  }
  .login-page {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
  }
  .login-container {
    margin-top: 2vh;
    width: 50vh;
    height: 50vh;
    border: 1px solid gray;
  }
  label {
    margin-left: 10%;
    text-align: center;
  }
  input[type=text] {
    width: 80%;
    padding: 12px 40px; 
    margin-left: 10%;
    height: 5vh;
    background-color: rgba(50, 56, 77, 0.527);
    border: none;
    outline: none;
    font-size: 20px;
  }
  .username {
    position: relative;
    margin-top: 2vh;
  }
  .username i {
    position: absolute;
    left: 15px;
    top: 40px;
    color: gray;
  }
  .password i {
    position: absolute;
    left: 10%;
    top: 37%;
    color: gray;
  }
  * {
    font-family: "Noto Sans", sans-serif;
  }
</style>