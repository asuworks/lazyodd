# ODD Guidance and Checklists Reference

This document provides guidance and checklists for writing ODD descriptions of agent-based or other simulation models, based on the ODD+2 protocol (Grimm et al. 2020, building on Grimm et al. 2006, 2010). An ODD description should follow all seven elements in order, be complete enough for model reproduction, and use the hierarchical Overview-Design concepts-Details structure.

The model description should be preceded by: "**The model description follows the ODD (Overview, Design concepts, Details) protocol for describing individual- and agent-based models (Grimm et al. 2006), as updated by Grimm et al. (2020).**"

---

# 1. Purpose and patterns

Every model has to start from a clear question, problem, or hypothesis; readers cannot understand your model unless they understand its purpose. Therefore, ODD starts with a concise and specific statement of the purpose(s) for which the model was developed. It is useful to first identify one or more general types of model purpose (e.g., prediction, explanation, description, theoretical exposition, illustration, analogy, and social learning) before stating the specific purpose.

The "patterns" part of this element helps clarify the model purpose by specifying the criteria you will use to decide when your model is realistic enough to be useful for its purpose. The patterns are observations, at the individual or system level, that are believed to be driven by the same processes, variables, etc. that are important for the model's purpose. Including patterns in ODD is also a way to link it explicitly to "pattern-oriented modeling".

### Guidance

**Make the purpose specific, addressing a clear question.** The purpose statement should be specific enough to enable a reader to independently judge a model's success at achieving this purpose as well as to serve as the primary "filter" for what is and is not in the model: ideally the model should only include entities and mechanisms that are necessary to meet its purpose. If the purpose statement is only general and unspecific, and especially if it lacks patterns for evaluating the model's usefulness, then it will be difficult to justify (and make) model design decisions.

Some ODDs state only that the model's purpose is to "explore," "investigate," or "study" some system or phenomenon, which is not specific enough to assess the model or to determine what the model needs to contain. An imprecise purpose such as this is often an indication that the modeler simply assembled some mechanisms in an ABM and explored its results. Studies like this can be made more scientific by stating the purpose as a clear question such as "To test whether the mechanisms A, B, and C can explain the observed phenomena X, Y, and Z."

**Include the higher-level purpose.** The purpose statement should also clarify the model's higher-level purpose: whether it is to develop understanding of the system, or to make specific predictions, etc. Different high-level purposes lead to different model designs.

**Tie the purpose to the study's primary results.** One way to make this statement of model purpose specific enough is to explicitly consider what point you are trying to demonstrate with the model. The statement should allow the readers to clearly judge the extent to which the model is successful. This is closely related to the primary analysis you will conduct with the model. Think about the key graph(s) you will produce in your "Results" section, where you apply the model to your main research question. The model's purpose should include producing the relationship shown in this graph.

**Define your terms.** If you state that your model's purpose is (for example) to "predict how the vulnerability of a community to flooding depends on public policy", you still have not stated a clear model purpose. The term "vulnerability to flooding" could mean many things: drowning, travel delays, property damage, etc.; and "public policy" could refer to zoning, insurance, or emergency response. Be clear about exactly what inputs and results your model addresses.

**Be specific to this version of the model.** To keep the description clear and focused, do not discuss potential future modifications of the model to new purposes or patterns. However, if the same model is designed for multiple purposes, those purposes should be described even if they are not addressed in the current publication.

**Do not describe the model yet.** Authors are often tempted to start describing how the model works here in the purpose statement, which is a mistake. Instead, address only the purpose here and then, in subsequent sections, you can tie the model's design to the purpose by explaining why specific design decisions were necessary for the model's purpose.

**Make this purpose statement independent.** Model descriptions are typically published in research articles or reports that also include, in their introduction, a statement of the study's purpose. This ODD element should be independent of any presentation of study purpose elsewhere in the same document, for several reasons: (a) an ODD description should always be complete and understandable by itself, and (b) re-stating the model purpose as specifically as possible always helps modelers (and readers) clarify what should be in the model.

**Use qualitative but testable patterns.** Patterns useful for designing and evaluating ABMs are often general (observed at multiple locations or times) and qualitative. However, using patterns to evaluate a model requires that they be testable: you need a reproducible way to determine whether the model matches the pattern. Making patterns testable can be as simple as stating them as qualitative trends, e.g., that output X increases as variable A decreases.

**Document the patterns.** A complete description of the patterns used in modeling needs to document why the patterns were selected: what evidence supports them, and what is their role in justifying the purpose? Documenting patterns can range from simply stating them as widespread (or your own) beliefs, to citing multiple empirical studies that observed each pattern. Thorough documentation of several patterns can require substantial text, which could conflict with keeping this "Overview" part of ODD short. In this case, patterns can be thoroughly documented in a separate section of a report or article and summarized in the ODD description.

### Checklist

The ODD text for this element should describe:

- The model's specific purpose(s).
- The patterns used as criteria for evaluating the model's suitability for its purpose.

### Example

[Carter N, Levin SA, Barlow A, Grimm V. 2015. Modeling tiger population and territory dynamics using an agent-based approach. Ecological Modelling 312: 347-362]

> The proximate purpose of the model is to predict the dynamics of the number, location, and size of tiger territories in response to habitat quality and tiger density... The ultimate purpose of the model, which will be presented in follow-up work, is to explore human-tiger interactions.

---

# 2. Entities, state variables, and scales

This ODD element describes the things represented in the model (also called an "ontology"). It includes three closely related parts.

The first part describes the model's entities. An entity is a distinct or separate object or actor that behaves as a unit. ABMs typically have several *kinds* of entities and one or more entities of each kind. The following types of entities are typical:

- Spatial units such as grid cells or GIS polygons. In spatially explicit models, these entities represent variation in conditions over space. Some models represent agent "locations" in non-geographic spaces, including networks.
- Agents or individuals. An ABM can have one or several types of agents that should each be described separately.
- Collectives (as described in Element 4, below). If the model includes agent collectives that are represented as having their own variables and behaviors, then they are also entities to describe.
- Environment. Many models include a single entity that performs functions such as describing the environment experienced by other entities and keeping track of simulated time. Any global variables essential to the model, such as those describing the environment, should be associated with such an entity.

The second part of this element is a description of the state variables (sometimes called "attributes") of each kind of entity. State variables of an entity are variables that characterize its current state; a state variable either distinguishes an entity from other entities of the same kind, or traces how the entity changes over time. In addition to listing each kind of entity's state variables, an ODD description should also describe the characteristics of each variable:

- What exactly does the variable represent (including its units if it has units)?
- Is the variable dynamic (changing over time) or static (never changing in time)?
- Type: is the variable an integer, a floating-point number, a text string, a set of coordinates, a boolean (true/false) value, a probability?
- Range: can the variable have only a few discrete values, is it a number with limited range, or can it have any value?

It is usually convenient to list each kind of entity's state variables and their characteristics in a table.

The third part of this element is describing the model's spatial and temporal scales. By "scales" we mean the model's *extent* -- the total amount of space and time represented in a simulation -- and *resolution* -- the shape and size of the spatial units and the length of time steps.

### Guidance

**Provide the rationale for the choice of entities.** Choosing which kinds of entities to include in a model, and which to leave out, is a very fundamental and important design decision. Often this choice is not straightforward: different models of the same system and problem may contain different entities. Therefore, it is important for making your model scientific instead of arbitrary to explain why you chose its entities.

**Include networks and collectives as entities if they have their own state variables and behaviors.** ABMs can represent networks or other collectives as either (1) entities with their own state variables and behaviors or (2) emergent properties of other agents. Collectives of the first type should be described in this ODD element, while those of the second type should not. Do not include networks as model entities if they exist only as links among agents or can otherwise be completely described by the characteristics of their members.

**Do not confuse parameters with state variables.** Parameters are coefficients or constants used in model equations and algorithms. Be careful to include as state variables only those meeting the criteria stated above: they define how an entity's state varies over time or how state varies among entities of the same type. By these criteria, the variables of a unique entity (e.g., the Observer or the global environment) are state variables if they vary over time and parameters if they are static.

**Do not include all of an entity's variables as state variables.** The list of state variables should rarely include all the entity's variables in the computer code. State variables should be "low level" in the sense that they cannot be calculated from other state variables; do not include variables that are readily calculated from other variables. One way to define state variables is: if you want to stop the model and save it in its current state, so it can be re-started in exactly the same state, what is the minimum information you must save? Those essential characteristics of each kind of entity are its state variables.

**Do not yet describe when or why state variables change or what entities do.** This element of ODD is simply to describe what is in the model, not what those things do. Save *all* discussion of what happens during simulations for later elements.

**Describe whether the model represents space, and how.** Not all ABMs are spatial. The discussion of spatial scales should start by saying whether space is represented. State whether the model is one-, two-, or three-dimensional. Many ABMs are two-dimensional and represent space as a collection of discrete units ("cells" or "patches"). Space can also be represented as continuous. If a model uses toroidal space, the description needs to say so.

**Describe whether the model represents time, and how.** Most ABMs represent time via discrete time steps. However, some models also represent some processes as occurring in continuous time. An ODD description needs to say whether the model uses time steps and how long these steps are, and also identify any processes that are instead modeled using continuous time.

**Describe whether the model represents any dimensions other than time and space.** It is possible for ABMs to use dimensions other than physical ones. If any such alternative dimensions are used, describe them as you would space.

**For abstract models without specific scales, provide an approximation or conceptual definition of scales.** Some ABMs are not built to represent a specific real system, so their spatial and temporal scales are not clearly specified. For such models, the ODD description should at least describe what the time steps and spatial units represent conceptually and approximate their scale.

**When spatial or temporal scales are not fixed, describe typical values.** Some models are designed for application to multiple systems. In such cases, the ODD description should state which scales are fixed vs. variable, and provide the range of typical values for the scales that vary.

**Provide the rationales for spatial and temporal scales.** Choosing the scales is well-known as a critical design decision because model scales can have effects that are strong yet difficult to identify. This is an especially important part of your model to justify.

**Describe scales in a separate paragraph.** We recommend writing a separate paragraph that concisely states the spatial and temporal scales. These are fundamental characteristics of a model that readers will often want to find easily.

**Do not discuss model processes and behaviors.** While identifying the entities and their state variables here, it is tempting to also describe how they are initialized and the processes that cause them to change. However, those topics are instead described in elements 3 and 5.

### Checklist

### Describe:

- The kinds of entities in the model and what they represent.
- Why those entities were included and, if relevant, why other entities were not included.
- The state variables of each kind of entity, usually in a table. For each state variable, describe exactly what it represents, its units, whether it is dynamic or static, its type, and its range.
- Whether the model represents time and, if so, whether time is represented via discrete time steps, as continuous, or both. If time steps are used, define their length (the temporal resolution). Describe how much time is represented in a simulation (the temporal extent).
- Whether the model represents space and, if so, whether space is represented as discrete spatial units, as continuous, or as both. If discrete spatial units are used, describe their shape and size (the spatial resolution). Describe how much total space is represented (the spatial extent).
- Whether any other dimensions are represented, and how.
- Why the spatial and temporal scales were chosen.

### Example

[Railsback SF, Johnson MD. 2011. Pattern-oriented modeling of bird foraging and pest control in coffee farms. Ecological Modelling, 222: 3305-3319]

> Scales. The model's spatial extent is a square of 200 x 200 square cells, each 5 m x 5 m in size; hence, the total area is 100 ha. This relatively fine resolution was chosen so the model can represent the effects of the small patches of trees and other habitat types that typify Jamaican coffee farms. The model's space is represented as bounded, not toroidal. The model runs at a 1-day time step, except that bird habitat selection and foraging is modeled at much shorter time step during daytime hours. This "foraging time step" is a parameter with value of 0.0167 h (1 min). The time period modeled represents the period when CBB infest berries and when North American birds winter in Jamaica. The model runs for 151 days representing December 1 to April 30.

---

# 3. Process overview and scheduling

The main purpose of this element is to provide a summary overview of what the model does as it executes: what processes are executed, in what order. (The details of these processes, except for very simple ones, are fully described in Element 7.) At the same time, the element describes the model's scheduling -- the order in which the processes are executed -- in complete detail.

A model's schedule specifies the order in which it executes each process, on each time step. We recommend describing the schedule here as a list of what simulation modelers call "actions". An action specifies (1) which entity or entities (2) execute which process or behavior that (3) changes which state variables, and (4) the order in which the entities execute the process. A simple example schedule is:

- 1. The environment executes its "update" submodel, which updates its state variables *date*, *temperature*, *rainfall*, and the value of the habitat cell state variable *food-availability*.
- 2. The agents each execute their "adapt" submodel, in which they choose a new location in response to the new environmental conditions. The agents do this in order of highest to lowest value of their state variable *body-weight*.
- 3. The agents execute their "grow and survive" submodel in which they (a) update their *body-weight* variable by how much they grow, and (b) either live or die. The agents execute this action in an order that is randomized each time step.
- 4. The display and file output are updated.

Actions can be hierarchical: one action can include executing other actions. For most ABMs the Process overview and scheduling element should start with a summary of the schedule: a concise list of actions. The summary is then followed by discussion as necessary to (1) fully explain any scheduling that does not follow simple time steps, and (2) provide the rationale for the choice of processes in the model and how they are scheduled.

### Guidance

**Be complete: include everything that is executed each time step.** Remember that while this ODD element is intended as an overview of how the model executes, it is the only place in ODD that describes exactly what actions are executed and their order of execution.

**Describe the execution order.** For any action that is executed by more than one entity, you must specify the order in which the agents execute. Sometimes the execution order is unimportant, but often it is a very important characteristic of the model.

**Make sure the schedule summary says when state variables are updated.** The only purpose of the model's processes and submodels is to update the entity state variables as simulated time proceeds. An essential part of this element is therefore to say exactly when the state variables of each entity are changed. Use the list of state variables in Element 2 as a checklist and make sure this element describes when they are updated. If the agents update a shared variable that affects other agents, say whether the model uses "asynchronous updating" or "synchronous updating".

While Element 3 describes what happens each time step, the time step length and temporal extent of simulations should be described only in Element 2.

**Provide the rationale for the processes and scheduling, as a separate discussion.** This element is the place to explain why you chose to include the processes in the model and to exclude other processes. This is also where to justify why you scheduled the processes as you did. Scheduling can have very strong effects on model results so should be considered carefully. These explanations should be written as paragraphs that come after the schedule summary.

**Keep the overview concise.** This element is not the place to explain model processes in detail. Actions are typically described simply by saying which submodel is executed, with a cross-reference to the submodel's complete description in Element 7. However, extremely simple processes can be fully described here.

**Use diagrams like flow charts if they are helpful for specific actions, but they are rarely sufficient by themselves.** Flow charts can be helpful for explaining more complicated scheduling of an ABM. However, flow charts rarely can define an ABM's schedule completely, clearly, and accurately by themselves.

**If necessary, use pseudo-code (but not actual program statements) to clarify execution order.** Pseudo-code -- natural language statements that include logic similar to computer code -- can be useful for describing complex logic. Do not use actual programming statements from the model's code in ODD.

**If your model includes actions scheduled as discrete events in continuous time steps, summarize how those events are scheduled.** Supplement the process overview and schedule with a list of those actions and say in general how they are scheduled (what causes an event to be scheduled for execution and what determines when it executes). Complete details should be provided in the submodel descriptions of Element 7.

### Checklist

### Provide:

- A complete but concise model schedule that defines exactly what happens each time step. The schedule should be presented as a hierarchy of "actions" that each describe which entity or entities execute which process or submodel, which state variables are updated, and (for actions executed by multiple entities such as all agents or spatial cells) the order in which the entities execute it.
- A separate discussion, if needed, that summarizes how actions executed in continuous time instead of discrete time steps are scheduled.
- A discussion providing the rationale for why the model includes the processes it does.
- A discussion providing the rationale for how the actions are scheduled. Why are the actions executed in the given order? For those actions executed by multiple entities, why did you choose the order in which the entities execute?

### Example

[Evers E, de Vries H, Spruijt BM, Sterck EH. 2014. The EMO-model: an agent-based model of primate social behavior regulated by two emotional dimensions. PloS one 9: e87955]

> Our model is event-driven. While most social behaviors are discrete events in time, moving, resting and grooming are modeled as continuous duration behaviors. Therefore, time is modeled on a continuous scale. Each time, the agent with the lowest schedule time is activated first. Whenever an individual is activated, first all model entities update those state variables that may have increased or decreased over the time interval that has passed since the last activation of an entity. If the activated individual had scheduled a movement action, that action is executed. Else, ego checks the grouping criteria and employs grouping, if necessary. If no grouping and no movement are to be performed, ego may select either a social behavior, or resting or random movement within the group.

[Example truncated for brevity]

---

# 4. Design concepts

The Design concepts element describes how 11 concepts that characterize ABMs were implemented in the model. This element is not needed to describe exactly what the model does or to replicate it, but instead is intended to place the model within a common conceptual framework and to show how its developers thought about its design.

The design concepts are intended to capture important characteristics of ABMs that are not described well by traditional description methods such as equations and flow charts. The concepts serve as a checklist of important design decisions that should be made consciously and documented. The concepts are also useful as a way to categorize, compare, and review ABMs.

Some of the design concepts -- especially Learning and Collectives -- are not used in most ABMs, and few models use all the other concepts. For the concepts that your model does not use, provide a simple statement such as "Learning is not implemented" or "The model includes no collectives."

The Design concepts element is a particularly important place to provide the rationale for model design decisions. For each design concept, provide a general description of its use with (if relevant) citations for literature supporting that use. Use cross-referencing to point readers to the submodel descriptions (Element 7) where full details are described.

## Basic principles

This concept relates the model to existing ideas, theories, hypotheses, and modeling approaches, to place the model within its larger context. These principles can occur at both the model level (e.g., does the model address a question that has been addressed with other models and methods?) and at the agent level (e.g., what theory for agent behavior does the model use, and where did this theory come from?). Describing such basic principles makes a model seem more a part of science and not made up without consideration of previous ideas.

### Describe:

- The general concepts, theories, hypotheses, or modeling approaches underlying the model's design, at both the system and agent levels.
- How these basic principles are taken into account. Are they implemented in submodels or is their scope the system level? Is the model designed to provide insights about the basic principles themselves, i.e. their scope, their usefulness in real-world scenarios, validation, or modification?
- Whether the model uses new or existing theory for the agent behaviors from which system dynamics emerge. What literature or concepts are agent behaviors based on?

### Example

[Wild Dog Model, Chapter 16 of Railsback and Grimm (2019)]

> This model addresses a classic problem of conservation ecology known as population viability analysis (PVA). This model differs from classical PVA models in two ways. First, it is not simply a population-level model but instead explicitly represents lower levels of organization within the population. Second, while this model is highly stochastic, it is also driven by mechanistic processes and adaptive behavior within the population.

[Example truncated for brevity]

## Emergence

This concept addresses a fundamental characteristic of ABMs: that system behavior can emerge from the behavior of agents and from their environment instead of being imposed by equations or rules. However, the degree to which results are emergent or imposed varies widely among models. This concept therefore describes which model results emerge from which mechanisms and which results instead are imposed.

This element should identify which model results emerge from, or are imposed by, which mechanisms and behaviors, but should not address *how* such mechanisms and behaviors work; that explanation begins with the following concept.

### Describe:

- Which key model results or outputs are modeled as emerging from the adaptive decisions and behaviors of agents. These results are expected to vary in complex and perhaps unpredictable ways when particular characteristics of the agents or their environment change.
- For those emergent results, the agent behaviors and characteristics and environment variables that results emerge from.
- The model results that are modeled not as emergent but as relatively imposed by model rules. These results are relatively predictable and independent of agent behavior.
- For the imposed results, the model mechanisms or rules that impose them.
- The rationale for deciding which model results are more vs. less emergent.

### Example

[Railsback SF, Johnson MD. 2011. Pattern-oriented modeling of bird foraging and pest control in coffee farms. Ecological Modelling, 222: 3305-3319]

> The model's primary results -- pest insect infestation rates in two types of coffee production -- and intermediate results such as bird abundance and spatial distributions of birds emerge from the amount and spatial distribution of the six habitat types, the seasonal abundance of pest insects, the number of birds, and the foraging behavior of birds.

[Example truncated for brevity]

## Adaptation

This concept identifies the agents' adaptive behaviors: what decisions agents make, in response to what stimuli. All such behaviors should be identified and described separately. The description should include components of behavior such as: the alternatives that agents choose among; the internal and environmental variables that affect the decision; and whether the decision is modeled as "direct objective seeking", in which agents rank alternatives using a measure of how well each would meet some specific objective, or as "indirect objective seeking", in which agents simply follow rules that reproduce observed behaviors that are implicitly assumed to convey success.

Many ABMs include only very simple behaviors that can be hard to think of as adaptive or even as decisions. However, even such simple responses should be described as adaptive behaviors in ODD.

At the other extreme are ABMs that use complex evolved behaviors: each agent has an internal decision model such as an artificial neural network that is evolved in the ABM to produce useful adaptive behavior. This approach can still be described in the framework provided here.

### Describe, for each adaptive behavior of the agents:

- What decision is made: what about themselves the agents are changing.
- The alternatives that agents choose from.
- The inputs that drive each decision: the internal and environmental variables that affect it.
- Whether the behavior is modeled via direct objective-seeking -- evaluating some measure of its objectives for each alternative -- or instead via indirect objective-seeking -- causing agents to behave in a way assumed to convey success, often because it reproduces observed behaviors.
- If direct objective-seeking is used, how the objective measure is used to select which alternative to execute (e.g., whether the agent chooses the alternative with the highest objective measure value, or the first one that meets a threshold value).

### Example

[From the description by Railsback and Grimm (2019; Chapter 22) of the NetLogo Segregation model.]

> The model households have one adaptive behavior: deciding whether or not to move to another location and, if so, selecting a new location. The decision of whether to move is modeled as direct objective seeking: a household moves if its objective measure is below a "tolerance threshold". This approach can be considered a type of satisficing -- making a decision to achieve an acceptable level of the objective instead of maximizing it.

## Objectives

This concept applies to adaptive behaviors that use direct objective-seeking; it defines the objective measure used to evaluate decision alternatives. (In economics, the term "utility function" is often used for an objective measure; in ecology, the term "fitness measure" is used.) If adaptive behaviors are modeled as explicitly acting to increase some measure of the individual's success at meeting some objective, what is that measure, what does it represent, and how is it calculated?

Note that agents that are part of a Collective or larger system can be modeled as having objectives that serve not themselves but the larger system they belong to.

### Describe, for each adaptive behavior modeled as direct objective-seeking:

- What the objective measure represents: what characteristic of agent success does it model?
- What variables of the agent and its environment drive the objective measure.
- How the measure is calculated. If it is a simple equation or algorithm, it can be described completely here; otherwise, provide a cross-reference to the submodel in Element 7 that describes it completely.
- The rationale behind the objective measure: why does it include the variables and processes it does?

### Example

[Business Investor model. Chapter 10 of Railsback and Grimm (2019).]

> Investors rate business alternatives by an objective measure (utility measure, in economics) that represents their expected future wealth at the end of a time horizon (T, a number of future years) if they buy and operate the business. This expected future wealth is a function of the investor's current wealth and the profit and failure risk offered by the patch: U = (W + TP) (1 - F)^T where U is the expected utility for the patch, W is the investor's current wealth, P is the annual profit of the patch, and F is the probability per year of the business failing.

## Learning

This concept refers to agents that change how they produce adaptive behavior over time as a consequence of their experience. Learning does not refer to how adaptation depends on state variables that change over time; instead, it refers to how agents change their decision-making methods (the algorithms or perhaps only the parameters of those algorithms) as a consequence of their experience. While memory can be essential to learning, not all adaptive behaviors that use memory also use learning. Few ABMs so far have included learning, even though a great deal of research and theory addresses how humans, organizations, and other organisms learn.

### Describe:

- Which adaptive behaviors of agents are modeled in a way that includes learning.
- How learning is represented, especially the extent to which the representation is based on existing learning theory.
- The rationale for including (or, if relevant, excluding) learning in the adaptive behavior, and the rationale for how learning is modeled.

### Example

[Gimona A., Polhill, JG. 2011. Exploring robustness of biodiversity policy with a coupled metacommunity and agent-based model. Journal of Land Use Science 6: 175-193]

> The adaptive behavior of land managers -- deciding what land use to select -- is modeled using an approach that includes learning. This submodel is based on "case-based reasoning" theory (Aamodt and Plaza 1994). This approach assumes decisions are based on memory of previous decisions in similar cases and their outcomes. The land manager agents use their own memories of previous decisions, but if their memory contains no similar cases they can use the memory of neighboring land managers.

[Example truncated for brevity]

## Prediction

Prediction is fundamental to successful decision-making and, often, to modeling adaptation in an ABM. Some ABMs use "explicit prediction": the agents' adaptive behaviors or learning are based on explicit estimates of future conditions and future consequences of decisions. For these ABMs, explain how agents predict future conditions and decision consequences. What internal models of future conditions or decision consequences do agents use to make predictions for decision-making?

Models that do not include explicit prediction often include "implicit prediction": hidden or implied assumptions about the future consequences of decisions. A classic example of implicit prediction is that following a gradient of increasing food scent will lead an agent to food.

### Describe:

- How the models of adaptive behavior use either explicit or implicit prediction.
- The rationale for how prediction is represented: is the model designed to represent how the agents actually make predictions? Or is prediction modeled as it is simply because it produces useful behavior?

### Example

[From the description by Railsback and Grimm (2019; Chapter 22) of the NetLogo Segregation model.]

> The adaptive behavior of households is based on the implicit prediction that moving when the objective measure is below the tolerance threshold is likely to eventually result in the household occupying a location where the tolerance threshold is met permanently.

## Sensing

This concept addresses what information agents "know" and use in their behaviors. The ability to represent how agents can have limited or only local information is a key characteristic of ABMs. Here, say which state variables of which entities an agent is assumed to "sense", and how.

Most often, sensing is modeled by simply assuming that the agent accurately knows the values of some variables, neglecting how the agent gets those values or any uncertainty in their values. But ABMs can model the actual sensing process when that process is important to the model's purpose. And ABMs can represent uncertainty in sensing.

Describing sensing includes stating which variables of which entities are sensed. The description must cover what an agent knows about its own state. When agents sense variables from other entities, we must specify exactly how they determine which entities they sense values from. In ABMs, sensing is often assumed to be local, but can happen through networks or can even be assumed to be global.

### Describe:

- What state variables, of themselves and other entities, agents are assumed to sense and use in their behaviors. Say exactly what defines or limits the range over which agents can sense information.
- How the agents are assumed to sense each such variable: are they assumed simply to know the value accurately? Or does the model represent the mechanisms of sensing, or uncertainty in sensed values?
- The rationale for sensing assumptions.

### Example

[Railsback SF, Johnson MD. 2011. Pattern-oriented modeling of bird foraging and pest control in coffee farms. Ecological Modelling, 222: 3305-3319]

> Birds are assumed able to perfectly sense the current availability of both types of prey in cells within a specified radius of their current cell. This radius is constant over time and space and among birds; its value is the model parameter *forage-radius* (meters).

## Interaction

The ability to represent interaction as local instead of global is another key characteristic of ABMs. This concept addresses which agents interact with each other and how.

We distinguish two very common kinds of interaction among agents: direct and mediated. Direct interaction is when one agent identifies one or more other agents and directly affects them, e.g. by trading with them, having some kind of contest with them, or eating them. Mediated interaction occurs when one agent affects others indirectly by producing or consuming a shared resource; competition for resources is typically modeled as a mediated interaction.

Communication is an important type of interaction in some ABMs: agents interact by sharing information. Like other kinds of interaction, communication can be either direct or mediated.

### Describe:

- The kinds of interaction among agents in the model, including whether each kind is represented as direct or mediated interaction.
- For each kind of interaction, the range (over space, time, a network, etc.) over which agents interact. What determines which agents interact with whom?
- The rationale for how interaction is modeled.

### Example

[Telemarketer model, Chapter 13 of Railsback and Grimm (2019).]

> There are two kinds of interaction in this model: between telemarketers and potential customers, and among the telemarketers. The telemarketers interact directly with potential customers by communicating to find out whether the customers will buy. The telemarketers' interactions with each other are mediated by the resource they compete for: customers. Both of these kinds of interaction are local because telemarketers are assumed able to call only customers within a radius of their location.

[Example truncated for brevity]

## Stochasticity

Here, describe where and how stochastic processes -- those driven by pseudorandom numbers -- are used in the model. While some ABMs base most of their processes on random events, others can produce highly variable results with no stochasticity at all.

In general, stochastic processes are used when we want some part of a model to have variation but we do not want to model the mechanisms that cause the variability. Common uses of stochasticity in ABMs:

1. **Variability in initial conditions:** When creating agents at the start of a simulation, using pseudorandom number distributions to set the initial values of some state variables so agents are not identical.
2. **Simplifying submodels:** Assuming that an agent dies if a random number between 0.0 and 1.0 is greater than its survival probability.
3. **Matching observed frequencies:** Modeling agent behaviors to use different alternatives with the same frequency as real agents have been observed to.

### Describe:

- Which processes are modeled as stochastic, using pseudorandom number distributions to determine the outcome.
- Why stochasticity was used in each such process. Often, the reason is simply to make the process variable without having to model the causes of variability; or the reason could be to make model events or behaviors occur with a specified frequency.

### Example

[From the description by Railsback and Grimm (2019; Chapter 22) of the NetLogo Segregation model.]

> *Stochasticity* is used in two ways. First, the model is initialized stochastically in such a way that the total number of households, whether each location is occupied initially, the color of each household, and the number of households of each color, are all stochastic. These initialization methods are stochastic so that the model can be assumed unsegregated at the start of a simulation. Second, when a household decides to move, its choice of new location is stochastic (but not completely random). The new location of households when they move is stochastic because modeling the details of movement is unnecessary for this model.

## Collectives

Collectives are aggregations of agents that affect, and are affected by, the agents. They can be an important intermediate level of organization in an ABM; examples include social groups, fish schools and bird flocks, and human networks and organizations. If the agents in a model can belong to aggregations, and those aggregations have characteristics that are different from those of agents but depend on the agents belonging to them, and the member agents are affected by the characteristics of the aggregations, then the aggregations should be described here as collectives.

Collectives can be modeled in two ways. First, they can be represented entirely as an emergent property of the agents. In this case, the collectives are not explicitly represented in the model. Second (and more common) is representing collectives explicitly as a type of entity in the model that does have state variables and its own behaviors.

### Describe:

- Any collectives that are in the model.
- Whether the collectives are modeled as emerging entirely from agent behaviors, or instead as explicit entities.
- In overview, how the collectives interact with each other and the agents to drive the behaviors of the entire system. (The details of these interactions will appear in other ODD elements.)

### Example

[Wild Dog model, Chapter 16 of Railsback and Grimm (2019).]

> This model includes two kinds of collectives, groups of wild dogs that strongly affect the individual dogs and are strongly affected by the individuals. The collectives are represented as specific kinds of model entity with their own state variables and behaviors. These entities are called packs and disperser groups. These collectives are included in the model because wild dogs have many cooperative behaviors and make decisions critical to the population's abundance and persistence in ways that depend on their group's state.

## Observation

This concept describes how information from the ABM is collected and analyzed, which can strongly affect what users understand and believe about the model. This concept can also be another place to tie the model design back to the purpose stated in Element 1.

Observation almost always includes summary statistics on the state of the agents and, perhaps, other entities. The ODD description needs to state how such statistics were observed: which state variables of which agents were observed at what times, and how they were summarized. It is especially important to understand whether analyses considered only measures of central tendency or also observed variability among agents.

Modelers sometimes also collect observations at the agent level, e.g., by selecting one or more agents and having them record their state over simulated time.

The ability to legitimately compare simulation results to data collected in the real world can be a major observation concern, leading some modelers to simulate, in their ABM, the data collection methods used in empirical studies. This "virtual scientist" technique strives to understand the biases and uncertainties in the empirical data by reproducing them in an ABM.

### Describe:

- The key outputs of the model used for analyses and how they were observed from the simulations. Such outputs may be simple and straightforward (e.g., means of agent state variables observed once per simulated week), or fairly complex (e.g., the frequency with which the simulated population went extinct within 100 simulated years, out of 1000 model runs).
- Any "virtual scientist" or other special techniques used to improve comparison of model results to empirical observations.

### Example

[Wild Dog model, Chapter 16 of Railsback and Grimm (2019).]

> The model's purpose is to study how potential management alternatives affect the persistence of dog populations, and one measure of a simulated population's persistence is the probability that it goes extinct within a certain number of years. This probability of extinction can be estimated as the fraction of replicate simulations in which no dogs are alive at the end. Here, the dog population's persistence is estimated as the fraction of 500 replicate simulations in which there are no dogs alive after 100 years.

---

# 5. Initialization

Elements 5-7 are the "Details" part of ODD: now your goal is to provide complete detail so that your model and its results can be reproduced. This element describes exactly how the model is initialized: how all its entities are created before the simulations start. Describing initialization includes specifying how many entities of each kind are created and how their state variables are given their initial values.

### Guidance

**Describe everything required to set up the model.** Initializing state variables usually includes more than just assigning numbers to entities; it can include setting agent locations in spatial models, building networks of agents, and creating any collectives that exist at the start of a simulation. Any actions or submodels that are executed only once, at the start of a simulation, should be considered part of initialization and described here.

**Explain whether initialization is intended to be case-specific or generic.** If your model is designed to simulate only one particular case or study system, say so. If instead your model is designed to be generally applicable to multiple sites, then the Initialization element must be more generic.

**Explain whether initialization is always the same or differs among scenarios.** Models are used by simulating different scenarios. Scenarios can differ from each other in how the model is initialized, or by varying factors such as input data or parameter values that affect results only after simulations start. If you vary the initial state of the model as part of simulation experiments, point out which state variables of which entities are varied among scenarios, and how.

**Describe data imported to create the model world.** If your model uses (for example) GIS data to define its simulated space, or reads in data used to define the initial agent populations, describe such data here. Describe where the data came from, why it was chosen, and how it was prepared. Discuss any uncertainties and limitations of the data, if relevant.

**Do not describe parameters and their values here.** The only parameters that should be described here are any used in initialization; parameters used in the rest of the model should be described in Element 7 with the submodel that uses them.

**Do not describe how new agents or entities are created during a simulation.** If your model creates new agents or other entities as it executes, describe that creation process as a submodel, not as part of initialization.

**Provide the rationale for initialization methods.** Your model becomes more scientific if you can explain initialization decisions such as determining which state variables vary among agents and how.

### Checklist

### Describe:

- What entities are created upon initialization, what determines how many of each are created, and how all their state variables are given initial values.
- How the initial locations of entities are set, if relevant.
- How any initial collectives, networks, or other intermediate structures are created.
- Any site-specific data used to initialize the model: the data types, their sources, how they were processed, any known biases or uncertainties, and how they were used in initialization.
- Whether simulation experiments will typically use scenarios that differ in initialization methods; if so, say how initialization will vary.
- The rationale for key initialization methods. For example, explain why initial agents vary among each other in the way they do.

### Example

[Lobo EP, Delic NC, Richardson A, et al. 2016. Self-organized centripetal movement of corneal epithelium in the absence of external cues. Nature communications 7: 12388]

> Cell positions are initially chosen so that the Voronoi diagram generated is a regular hexagonal grid (the distance between the positions of neighboring cells is a constant, *s*, known as the idealized cell diameter). All ESCs are given a random age (uniformly distributed from 0 to their lifespan), and a unique cell lineage identification code. Initially, all TACs are not assigned a lineage identification code. TACs derived from ESCs after initialization inherit the lineage identification code of their parent cell.

[Example truncated for brevity]

---

# 6. Input data

Model dynamics are often driven in part by input data, meaning time series of either variable values or events that describe the environment or otherwise affect simulations. "Driven" means that model state variables or processes are affected by the input, but the variables or events represented by the input are not affected by the model.

One common use of input data is to represent environment variables that change over time. Often, the input data are values observed in reality so that their statistical qualities are realistic. Alternatively, external models can be used to generate input. Input data can also describe external events that affect the model during a simulation.

### Guidance

**If the model does not use input data, simply say so.** In such cases, the ODD description should say "The model does not use input data to represent time-varying processes."

**Input data do not include parameter values or data used to initialize the model.** This element should only describe input used as the model executes to represent change over time in some particular state variable(s).

**Define the input data completely.** Say exactly what each input variable represents, provide its units, and describe how the input was or can be obtained. If any methods are used to manipulate data from common sources into the format used by the model, describe them. If relevant, describe uncertainties, biases, or other limitations of the data.

**If your ABM is intended to represent multiple scenarios that use different input data, describe the *kind* of input it needs.** If an ABM will be used for different sites or times, describe exactly what kind of input it needs.

**If input was generated from another model, document how.** If a "custom" model run was used to create input just for your model, then the methods need to be described either here, in another part of the same publication, or in another document that can be cited here.

### Checklist

### Describe:

- Whether the model uses any input data to represent variables that change over time or events that occur during a simulation.
- The input data: what it represents, its units, and its source.
- Any nontrivial methods used to collect or prepare the input.
- If input is from another model, how that model was used to generate the input.

### Example

[Chudzinska M, Ayllon D, Madsen J., Nabe-Nielsen J. 2016. Discriminating between possible foraging decisions using pattern-oriented modelling. Ecological Modelling 320: 299-315]

> Two input data files from external sources are used in the model: number of new super geese arriving to the model and distribution of habitat types within the modelled area. The number of arriving geese was assessed based on counts of geese on the roost sites in the years 2005-2012. New habitat map is loaded to the model at the beginning of each period.

[Example truncated for brevity]

---

# 7. Submodels

This element fully describes any submodels that were cited but not fully described in Element 3 or Element 5. Element 7 should include a subsection for each such submodel.

### Guidance

**Describe each submodel completely.** The primary concern with Element 7 is being complete: fully describing each submodel's equations, algorithms, parameters, and parameter values. Tables are often used to define parameters in one place; they should include each parameter's name, meaning, units, type, default value, range of values analyzed in the model, and information about where the values came from. Figures can complement the verbal description of the submodels.

Readers should be able to exactly reproduce each submodel from the ODD description.

**If helpful, break submodels into sub-submodels.** Submodel descriptions can be hierarchical: complex submodels are often best described as a set of sub-submodels that are each described separately. Some submodels may even justify a full ODD description of their own ("Nested ODD").

**Provide the rationale for submodel design.** For any process in a model, there are undoubtedly many possible submodel designs. Explaining how you arrived at your submodel design -- by searching the literature, applying theory, fitting statistical relations to data, exploring alternative approaches, etc. -- is very important for developing confidence in the full model.

**Include analyses of submodels.** A second way to develop confidence in submodels and the full ABM is to analyze submodels and show how they behave over all conditions that could occur during simulations. It is very common for ABMs to produce questionable output because their submodels produce unexpected results in some situations. The way to avoid such problems is to fully implement, calibrate, test, and explore each submodel before putting it in the full ABM. These analyses should be documented in the ODD.

### Checklist

### Describe:

- All of the submodels, in a separate subsection for each.
- For each submodel, its equations, algorithms, parameters, and how parameter values were selected.
- The analyses used to test, calibrate, and understand submodels by themselves.

### Example

[Piou C, Prevost E. 2012. A demo-genetic individual-based model for Atlantic salmon populations. Ecological Modelling 231: 37-52]

> Smoltification: Individual parr need to undergo a smoltification process to be able to leave the river. It is well documented that this physiological, behavioural and morphological process is a function of individual growth and that it is initiated much earlier than actually visible. It was therefore opted for an initiation time at the beginning of winter with an actual seaward migration at the beginning of summer. We used the probabilistic reaction norm depending on body length adjusted by Buoro et al. (2010) to simulate this process. An individual parr *j* would become a future smolt in autumn following the relation: logit(P(Sm_j = 1)) = aSm x (L_j - LmidSm) where *aSm* and *LmidSm* were population parameters and *Sm_j* was the binary indicator state variable.

[Example truncated for brevity]
