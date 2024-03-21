package net.sourceforge.plantuml.cheneer.command;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;

import net.sourceforge.plantuml.cheneer.ChenEerDiagram;
import net.sourceforge.plantuml.command.Command;
import net.sourceforge.plantuml.command.CommandExecutionResult;
import net.sourceforge.plantuml.core.UmlSource;
import net.sourceforge.plantuml.klimt.color.NoSuchColorException;
import net.sourceforge.plantuml.regex.IRegex;
import net.sourceforge.plantuml.regex.RegexResult;
import net.sourceforge.plantuml.utils.BlocLines;

@ExtendWith(MockitoExtension.class)
public class CommandEndGroupTest {

	private final Command<ChenEerDiagram> command = new CommandEndGroup();

	@Spy
	private final ChenEerDiagram diagram = new ChenEerDiagram(UmlSource.create(List.of(), false), null);

	@Test
	void test_parse() {
		IRegex regex = CommandEndGroup.getRegexConcat();
		RegexResult matcher = regex.matcher("}");

		assertThat(matcher).isNotNull();
	}

	@Test
	void test_execute() throws NoSuchColorException {
		diagram.pushOwner(null);

		BlocLines lines = BlocLines.singleString("}");
		CommandExecutionResult result = command.execute(diagram, lines);

		assertThat(result).matches(CommandExecutionResult::isOk);

		Mockito.verify(diagram).popOwner();
	}
}
