
/**
 * @author 庄展鹏
 * 2018-7-7
 * 创新实验室 WEB 培训选拔测试题--题3
 */
import java.util.TreeSet;
import java.util.Scanner;

public class Main {
	public static void main(String args[]) {
		Scanner input = new Scanner(System.in);
		TreeSet ts = new TreeSet();

		// 分开各元素并保存再数组中
		String str = input.nextLine();
		str = str.substring(1, str.length() - 1);
		String obj[] = str.split(",");
		// 添加到TreeSet中
		for (int i = 0; i < obj.length; i++) {
			obj[i] = obj[i].trim();
			ts.add(new input(obj[i]));
		}
		// 打印结果
		System.out.println(ts);
	}

}

class input implements Comparable {
	String value;

	// 构造方法
	public input(String value) {
		this.value = value;
	}

	// 重写toString方法
	public String toString() {
		return value;
	}

	// 重写compareTo方法
	public int compareTo(Object obj) {
		// System.out.println("调用了");
		input p = (input) obj;

		// 取首字符的ASCⅡ值
		int a = p.value.charAt(0);
		int b = this.value.charAt(0);

		// 如果是单引号或双引号的ASCⅡ值，则取下一个字符的ASCⅡ值，如果不是，则String类型转化为int类型
		if ((a == '\'') || (a == '\"')) {
			a = p.value.charAt(1);
		} else {
			a = Integer.parseInt(p.value);
		}
		// 同上
		if ((b == '\'') || (b == '\"')) {
			b = this.value.charAt(1);
		} else {
			b = Integer.parseInt(this.value);
		}

		if (a < b)
			return 1;
		if (a > b)
			return -1;
		return this.value.compareTo(p.value);
	}
}
