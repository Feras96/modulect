<?php
/**
* Will form the login page
* author Aqib Rashid
*/
   $mock = "";
   if(isset($_GET['mock'])) {
     $mock = $_GET['mock'];
   }
   ?>
<!doctype html>
<html>
   <head>
      <title>Modulect</title>
      <?php include 'includes/assets.php'; ?>
   </head>
   <body>
   <?php include 'includes/partial-header.php'; ?>
      <div id="page">
         <div class="container">
            <?php if($mock == "error"){?>
            <div class="row">
               <div class="col-md-10 col-md-offset-1">
                  <div class="flash-alert flash-alert-error">
                     <i class="fa fa-exclamation-triangle" aria-hidden="true"></i> You did something wrong.
                  </div>
               </div>
            </div>
            <?php }
               else if($mock == "success"){?>
            <div class="row">
               <div class="col-md-10 col-md-offset-1">
                  <div class="flash-alert flash-alert-success">
                     <i class="fa fa-check" aria-hidden="true"></i> You successfully did something.
                  </div>
               </div>
            </div>
            <?php } ?>
            <div class="row">
               <div class="col-md-5 col-md-offset-1">
                  <div class="col-md-12 login-card">
                     <h2>Log in</h2>
                     <div id="login-area">
                        <form>
                           <div class="form-group">
                              <label for="inputEmail" class="sr-only">Email address</label>
                              <input type="email" id="inputEmail" class="form-control" placeholder="Email: first.last@kcl.ac.uk" required autofocus>
                           </div>
                           <div class="form-group">
                              <label for="inputPassword" class="sr-only">Password</label>
                              <input type="password" id="inputPassword" class="form-control" placeholder="Password" required>
                           </div>
                           <div class="form-group">
                              <div class="checkbox">
                                 <input type="checkbox" id="remember-me" value="remember-me" checked="checked">
                                 <label for="remember-me">Remember me
                                 </label>
                              </div>
                           </div>
                           <div class="form-group">
                              <button class="btn btn-lg btn-block" type="submit">Log in&nbsp;&nbsp;<i class="fa fa-angle-right" aria-hidden="true"></i>
                              </button>
                           </div>
                           <div class="form-group">
                              <p style="margin-top:30px;"><a href="password-reset.php">Forgot your password?</a>
                              </p>
                           </div>
                        </form>
                     </div>
                  </div>
               </div>
               <div class="col-md-5">
                  <div class="col-md-12 login-card">
                     <h2>Register</h2>
                     <p>It's quick and simple to register. Once signed up, you can use Modulect as you want.</p>
                     <div style="margin-top:20px;"><a href="register.php" class="btn btn-lg btn-block">register&nbsp;&nbsp;<i class="fa fa-angle-right" aria-hidden="true"></i></a>
                     </div>
                  </div>
               </div>
            </div>
           
            <?php include 'includes/aftercontent.php' ?>
         </div>
      </div>
      <?php include 'includes/partial-footer.php'; ?>
   </body>
</html>