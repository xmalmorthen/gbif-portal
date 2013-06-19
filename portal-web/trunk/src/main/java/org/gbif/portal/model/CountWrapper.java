package org.gbif.portal.model;

import java.util.Collection;
import java.util.Collections;
import java.util.List;

import com.google.common.collect.Lists;
import com.google.common.primitives.Longs;

/**
 * Simple wrapper that adds a record count and a geo reference count to any object instance.
 */
public class CountWrapper<T> implements Comparable<CountWrapper<?>> {

  private final T obj;
  private long count;
  private long geoCount;

  public CountWrapper(T obj) {
    this.obj = obj;
  }

  public CountWrapper(T obj, long count) {
    this.obj = obj;
    this.count = count;
  }

  public CountWrapper(T obj, long count, long geoCount) {
    this.obj = obj;
    this.count = count;
    this.geoCount = geoCount;
  }

  /**
   * Creates a new list of given CountWrapper instances sorted by their counts.
   */
  public static <T> List<CountWrapper<T>> newSortedList(Collection<CountWrapper<T>> values) {
    List<CountWrapper<T>> byCount = Lists.newArrayList(values);
    Collections.sort(byCount);
    return byCount;
  }

  /**
   * @param values of counts
   * @return the sum of all count values
   */
  public static <T> long sum(Collection<CountWrapper<T>> values) {
    long total = 0;
    for (CountWrapper<?> d : values) {
      total += d.getCount();
    }
    return total;
  }

  @Override
  public int compareTo(CountWrapper<?> o) {
    return Longs.compare(this.getCount(), o.getCount());
  }

  public long getCount() {
    return count;
  }

  public long getGeoCount() {
    return geoCount;
  }

  public T getObj() {
    return obj;
  }

  public void increaseCount(long value) {
    count += value;
  }

  public void setCount(long count) {
    this.count = count;
  }

  public void setGeoCount(long geoCount) {
    this.geoCount = geoCount;
  }

}
