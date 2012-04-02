package org.gbif.cas;

import org.jasig.cas.authentication.handler.DefaultPasswordEncoder;
import org.jasig.cas.authentication.handler.PasswordEncoder;
import org.junit.Assert;
import org.junit.Test;

public class PasswordEncoderTest {

  @Test
  public void testMd5(){
    PasswordEncoder enc = new DefaultPasswordEncoder("MD5");
    Assert.assertEquals("25e7716e9d5329a2008e6558cb95d338", enc.encode("PIA"));
  }
}
