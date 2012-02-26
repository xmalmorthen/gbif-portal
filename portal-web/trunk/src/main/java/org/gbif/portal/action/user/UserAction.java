/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.gbif.portal.action.user;

import org.gbif.api.model.User;
import org.gbif.api.service.UserService;
import org.gbif.portal.action.BaseAction;
import org.gbif.portal.config.Constants;

import java.util.Date;

import com.google.inject.Inject;
import com.opensymphony.xwork2.validator.annotations.EmailValidator;

public class UserAction extends BaseAction {
  private User user;
  private String email;
  private String password;
  private String redirectUrl = "";

  @Inject
  private UserService userService;

  /**
   * Show user details.
   */
  @Override
  public String execute() {
    user = getCurrentUser();
    if (user == null){
      return INPUT;
    }
    return SUCCESS;
  }

  /**
   * login to webapp.
   */
  public String login() {
    // TODO: authenticate and get user from service
    // we simply create a new user here for testing
    user = userService.get(email);
    session.put(Constants.SESSION_USER, user);
    if (user == null){
      return INPUT;
    }
    user.setLastLogin(new Date());
    //userService.update(user);

    setRedirectUrlFromHeader();

    return SUCCESS;
  }

  private void setRedirectUrlFromHeader(){
    redirectUrl = getCurrentUrl();
    if (request != null) {
      final String referer = request.getHeader("Referer");
      if (referer != null && !(referer.endsWith("login") || referer.endsWith("register/step3"))) {
        redirectUrl = referer;
      }
    }
  }

  /**
   * logout.
   */
  public String logout() {
    session.clear();
    setRedirectUrlFromHeader();
    return SUCCESS;
  }

  /**
   * reset password
   */
  public String reset() {
    return SUCCESS;
  }

  public String getEmail() {
    return email;
  }

  @EmailValidator(message = "No valid email")
  public void setEmail(String email) {
    this.email = email;
  }

  public String getPassword() {
    return password;
  }

  public void setPassword(String password) {
    this.password = password;
  }

  public User getUser() {
    return user;
  }

  public String getRedirectUrl() {
    return redirectUrl;
  }
}
